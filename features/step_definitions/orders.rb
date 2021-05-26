Given('the market order is crossed with the limit order') do
    OrderBook.cross(@market_order, @limit_order)
end

Given('the limit order is crossed with the market order') do
    OrderBook.cross(@limit_order, @market_order)
end
  

Given('the orders are crossed') do
    OrderBook.cross(@order_1, @order_2)
end

Then('I should see no new trade created') do
    assert_equal Trade.first, nil
end

  
Then('I should see {string} new trade {string}') do |number, args|
  
    expected_trade = Trade.new
    key_values(expected_trade, args)
    
    assert_equal Trade.count, number.to_i

    Trade.all.each do |trade|
        assert trade.security_id == expected_trade.security_id
        assert trade.quantity == expected_trade.quantity
        assert_equal trade.price, expected_trade.price
        assert_equal trade.user_id, trade.order.user_id
        assert_equal trade.side, trade.order.side        
    end
end



Then('the order status must be updated correctly') do

    Order.all.each do |order|
        traded_qty = order.trades.sum(:quantity)
        assert_equal order.filled_qty, traded_qty
        assert order.quantity >= traded_qty

        if traded_qty == order.quantity
            assert_equal order.filled_qty, order.quantity
            assert_equal order.fill_status, Order::FILLED
            assert_equal order.open_qty, 0
        
        elsif traded_qty < order.quantity
            assert_equal order.filled_qty, traded_qty
            assert_equal order.fill_status, Order::PARTIAL
            assert_equal order.open_qty, order.quantity - traded_qty

        end
    
    end    
end


Then('the trade quantities should match the order filled quantity') do
    # All trades for a particular order must add up to the filled quantity
    Trade.group(:order_id).sum(:quantity).each do |order_id, qty|
        assert_equal Order.find(order_id).filled_qty, qty
    end
end
  

Then('I should see {string} new trades created') do |arg1|
    assert_equal Trade.count, arg1.to_i
end
  
  