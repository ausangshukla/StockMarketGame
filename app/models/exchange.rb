class Exchange < ApplicationRecord

    after_initialize do
        init_order_books()
    end

    # The order books for each symbol
    @order_books = {}

    def self.publish(exchange_name, order)
        Redis.new.publish(exchange_name, order.id)
    end
    
    
    def receive
        redis = Redis.new(timeout:0)
        redis.subscribe(name) do |on|
            on.message do |channel, order_id|
                begin
                    o = Order.find(order_id)
                    processOrder(o)
                rescue => error
                    logger.error "Error in processing #{order_id} #{error.message}"
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
        
        order_book.broadcastOrderBook(order)

    end

    
    # def get_order_book(symbol)
    #     @order_books[symbol]
    # end

    private

    # Returns the appropriate order book
    def init_order_books
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
