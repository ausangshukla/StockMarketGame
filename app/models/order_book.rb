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


    @queues = {Order::LIMIT + "-" + Order::BUY => @limit_buys,
        Order::LIMIT + "-" + Order::SELL => @limit_sells,
        Order::MARKET + "-" + Order::BUY => @market_buys,
        Order::MARKET + "-" + Order::SELL => @market_sells}

    def load        
        orders = Order.open.where(security_id: self.security_id)
        logger.debug "Loaded #{orders.count} orders for security_id = #{security_id}"
        orders.order("price").each do |order|
            process(order)
        end

        @limit_sells.sort!{|a, b|  a.price <=> b.price }
        @limit_buys.sort!{|a, b|  b.price <=> a.price }

        logger.debug "Sells: #{@limit_sells.size} Buys: #{@limit_buys.size}"
        self.print_book()
    end

    # When a new order comes into the system, it is processed
    # Either it will be fully crossed, partially crossed or enqueued to be crossed in the future
    def process(order)
        case [order.side]  
        when  [Order::BUY]
            # If we have sellers and the order is crossed 
            if @limit_sells.length > 0 && OrderBook.cross(order, @limit_sells[0])
                enqueue_order(order)
                dequeue_order(@limit_sells[0])          
            else
                # We are buying, but nobody is selling or the price is not right
                enqueue_order(order)
            end
        when [Order::SELL]            
            # If we have buyers and the order is crossed
            if @limit_buys.length > 0 && OrderBook.cross(order, @limit_buys[0])    
                enqueue_order(order)
                dequeue_order(@limit_buys[0])          
            else
                # We are selling, but nobody is buying or the price is not right
                enqueue_order(order)
            end
        end

    end



    def print_book        

        table = Terminal::Table.new title: "#{@security.symbol} : #{@security.id} : Order Book"  do |rows|
            rows << ["Order Id", "Buy Quantity", "Buy Price", "Order Id", "Sell Quantity", "Sell Price"]
            rows << :separator  

            buys_sells = @limit_buys.count > @limit_sells.count ? @limit_buys.zip(@limit_sells) : @limit_sells.zip(@limit_buys).map(&:reverse) 

            buys_sells.each do |b,s|
                # puts "Processing #{b}, #{s}"
                row = []
                b ? row.concat([b.id, b.quantity, b.price]) : row.concat([" ", " ", " "])
                s ? row.concat([s.id, s.quantity, s.price]) : row.concat([" ", " ", " "])
                rows << row
            end 
        end

        puts table
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


    def dequeue_order(order)

        if order.status == Order::CANCELLED || order.fill_status == "Filled"
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

end