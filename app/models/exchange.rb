class Exchange < ApplicationRecord

    # Stores all the exchanges available
    @@exchanges = {}

    # The order books for each symbol
    @order_books = {}


    def self.get(name)
        ex = @@exchanges[name]

        if ex == nil
            ex = Exchange.new(name: name)
            ex.init_order_books
            @@exchanges[name] = ex
        end
    
        @@exchanges[name]
    end

    def init_order_books
        Security.all.each do |sec|
            getOrderBook(sec)
        end
    end

    def all_order_books
        @order_books.values
    end

    def get_order_book(symbol)
        @order_books[symbol]
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
        
    end

    private

    # Returns the appropriate order book
    def getOrderBook(security)
        @order_books ||= Hash.new
        order_book = @order_books[security.symbol]
        
        if !order_book
            order_book ||= OrderBook.new(security_id: security.id, id: security.id, symbol: security.symbol) 
            @order_books[security.symbol] = order_book
        end

        order_book
    end

end
