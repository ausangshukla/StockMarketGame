Given('the order book is created for {string}') do |arg1|
    order = FactoryBot.build(:order)
    key_values(order, arg1)  
    @order_book = OrderBook.new(security_id: order.security_id)
end