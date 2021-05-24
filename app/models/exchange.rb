class Exchange < ApplicationRecord

    @order_books = {}

    def processOrder(order)
        @order_books ||= Hash.new
        order_book = @order_books[order.symbol]
        
        if !order_book
            order_book ||= OrderBook.new(security_id: order.security_id) 
            order_book.load
            @order_books[order.symbol] = order_book
        end

        order_book.process(order)
    end
end
