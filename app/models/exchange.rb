class Exchange < ApplicationRecord

    after_initialize do
        init_order_books()
    end

    # The order books for each symbol
    @order_books = {}

    # Sends a message to the OrderSimulator to simulate order creation
    def self.simulate(exchange_name, security_id, count=20)
        Redis.new.publish("simulator", 
            {exchange: exchange_name, security_id: security_id, count: count}.to_json)
    end

    # Used to send an order to the exchange for processing
    # This is only after the order has been saved in the DB
    def self.publish(exchange_name, order)
        Redis.new.publish(exchange_name, order.id)
    end
    
    # Used to broadcast the entire order book
    # This is used when we show the user book to the UI. Note order book current state is in memory only
    def self.broadcastOrderBook(exchange_name, security_id)
        Redis.new.publish("#{exchange_name}-broadcast", security_id)
    end
    
    
    # This is the core event loop for the exchange
    # It receives orders to process here
    def receive
        redis = Redis.new(timeout:0)
        redis.subscribe(name, "#{name}-reload", "#{name}-broadcast") do |on|
            on.message do |channel, id|
                begin
                    case channel
                        when name
                            o = Order.find(id)
                            processOrder(o)
                        when "#{name}-reload"
                            logger.info "Reloading order books at #{name}"
                            init_order_books
                        when "#{name}-broadcast"
                            sec = Security.find(id)
                            order_book = getOrderBook(sec)
                            logger.info "Broadcasting order book for #{sec.symbol} at #{name}"
                            sleep(1)
                            order_book.broadcastOrderBook()
                    end
                rescue => error
                    puts error.backtrace
                    logger.error "Error in processing #{id} #{error.message}"
                end
            end
        end
    end

    def processOrder(order)
        order_book = getOrderBook(order.security)

        case(order.status)
            when Order::OPEN
                order.created_at == order.updated_at ? order_book.newOrder(order) : order_book.modifyOrder(order)
            when Order::CANCELLED
                order_book.cancelOrder(order)
            else
                logger.error "Bad order status for Order #{order.id}"
        end 
        
        order_book.broadcastOrderBook()

    end

    
    private

    # Returns the appropriate order book
    def init_order_books
        @order_books = {}

        Security.all.each do |sec|
            getOrderBook(sec)
        end
    end

    def getOrderBook(security)
        @order_books ||= Hash.new
        order_book = @order_books[security.symbol]
        
        if !order_book
            order_book ||= OrderBook.new(security_id: security.id, id: security.id, symbol: security.symbol) 
            order_book.load()
            @order_books[security.symbol] = order_book
        end

        order_book
    end

end
