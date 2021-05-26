class OrderBook < ApplicationRecord
    include OrderBookConcern

    validates :symbol, :security_id, presence: true
    belongs_to :exchange

    after_initialize do
        @limit_buys = []
        @limit_sells = []
        @market_buys = []
        @market_sells = []
        @security = Security.find(security_id)
        self.load()
    end


    @queues = {
        Order::LIMIT + "-" + Order::BUY => @limit_buys,
        Order::LIMIT + "-" + Order::SELL => @limit_sells,
        Order::MARKET + "-" + Order::BUY => @market_buys,
        Order::MARKET + "-" + Order::SELL => @market_sells
    }

    
    def print
        OrderBook.print_book(@security, @market_buys, @market_sells, Order::MARKET)
        OrderBook.print_book(@security, @limit_buys, @limit_sells, Order::LIMIT)
    end

    def cancel_order(order)
        dequeue_order(order)
    end

    def modify_order(order)
        dequeue_order(order, force=true)
        process(order)
    end


    def crossWithPendingOrders(order, pendingOrders)
        pendingOrders.length > 0 && OrderBook.cross(order, pendingOrders[0]) 
    end

    # When a new order comes into the system, it is processed
    # Either it will be fully crossed, partially crossed or enqueued to be crossed in the future
    def process(order)

        puts "\nProcessing #{order}"

        case [order.side]  
            when  [Order::BUY]
                # If we have sellers and the order is crossed 
                while crossWithPendingOrders(order, @market_sells)
                    puts "Crossed #{order} \n with   #{@market_sells[0]}"
                    dequeue_order(@market_sells[0])          
                end
                while crossWithPendingOrders(order, @limit_sells)
                    puts "Crossed #{order} \n with   #{@limit_sells[0]}"
                    dequeue_order(@limit_sells[0])          
                end
                # We are buying, but nobody is selling or the price is not right
                enqueue_order(order)
                
            when [Order::SELL]            
                # If we have buyers and the order is crossed
                while crossWithPendingOrders(order, @market_buys)
                    puts "Crossed #{order} \n with   #{@market_buys[0]}"
                    dequeue_order(@market_buys[0])          
                end
                while crossWithPendingOrders(order, @limit_buys)    
                    puts "Crossed #{order} \n with   #{@limit_buys[0]}"
                    dequeue_order(@limit_buys[0])          
                end
                # We are selling, but nobody is buying or the price is not right
                enqueue_order(order)
                
        end

        self.print()
    end



    private
    def enqueue_order(order)

        if order.status == Order::OPEN && order.fill_status != "Filled"
            # We can enqueue only open and unfilled orders
            case order.price_type + "-" + order.side
                when Order::LIMIT + "-" + Order::BUY 
                    @limit_buys = @limit_buys.append(order).sort!{|a, b|  b.price <=> a.price }
                when Order::LIMIT + "-" + Order::SELL
                    @limit_sells = @limit_sells.append(order).sort_by{|o| o.price}
                when Order::MARKET + "-" + Order::BUY  
                    @market_buys.append(order)
                when Order::MARKET + "-" + Order::SELL
                    @market_sells.append(order)
                else
                    raise "Unknown Type of order"
            end

            return true
        else
            return false
        end    

    end


    def dequeue_order(order, force=false)

        if order.status == Order::CANCELLED || order.fill_status == "Filled" || force
            # We can enqueue only open and unfilled orders
            case order.price_type + "-" + order.side
                when Order::LIMIT + "-" + Order::BUY 
                    @limit_buys.delete(order)
                when Order::LIMIT + "-" + Order::SELL
                     @limit_sells.delete(order)
                when Order::MARKET + "-" + Order::BUY  
                    @market_buys.delete(order)
                when Order::MARKET + "-" + Order::SELL
                    @market_sells.delete(order)
                else
                    raise "Unknown Type of order"
            end

            return true
        else
            return false
        end    

    end

    def load        
        orders = Order.open.where(security_id: self.security_id).order("id asc")
        logger.debug "Loaded #{orders.count} orders for security_id = #{security_id}"
        orders.each do |order|
            process(order)
        end
        logger.debug "Sells: #{@limit_sells.size} Buys: #{@limit_buys.size}"
        print()
    end

end
