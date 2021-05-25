Given('the market order is crossed with the limit order') do
    @market_order.cross(@limit_order)
end

Given('the limit order is crossed with the market order') do
    @limit_order.cross(@market_order)
end
  

Then('I should see a new trade {string}') do |arg1|
    @trade = Trade.first
    expected_trade = Trade.new
    key_values(expected_trade, arg1)
    log "\n####Trade####\n" 
    log @trade.to_json

    assert @trade.security_id == expected_trade.security_id
    assert @trade.quantity == expected_trade.quantity
    assert_equal @trade.price, expected_trade.price
end


Then('the trade should have the right buyer and seller') do
    buyer_id = @market_order.side == Order::BUY ? @market_order.user_id : @limit_order.user_id
    seller_id = @market_order.side == Order::SELL ? @market_order.user_id : @limit_order.user_id
                
    assert @trade.buyer_id == buyer_id
    assert @trade.seller_id == seller_id
end
  

Then('the order status must be updated correctly') do
    if @trade.order.quantity == @trade.counterparty_order.quantity
        assert @trade.order.filled_qty == @trade.order.quantity
        assert @trade.order.fill_status == Order::FILLED
        assert @trade.order.open_qty == 0
        assert @trade.counterparty_order.filled_qty == @trade.order.quantity
        assert @trade.counterparty_order.fill_status == Order::FILLED
        assert @trade.counterparty_order.open_qty == 0
    
    elsif @trade.order.quantity < @trade.counterparty_order.quantity
        assert @trade.order.filled_qty == @trade.order.quantity
        assert @trade.order.fill_status == Order::FILLED
        assert @trade.order.open_qty == 0
        assert @trade.counterparty_order.filled_qty == @trade.order.quantity
        assert @trade.counterparty_order.fill_status == Order::PARTIAL
        assert @trade.counterparty_order.open_qty == @trade.counterparty_order.quantity - @trade.order.quantity

    elsif @trade.order.quantity > @trade.counterparty_order.quantity
        assert @trade.counterparty_order.filled_qty == @trade.counterparty_order.quantity
        assert @trade.counterparty_order.fill_status == Order::FILLED
        assert @trade.counterparty_order.open_qty == 0
        assert @trade.order.filled_qty == @trade.counterparty_order.quantity
        assert @trade.order.fill_status == Order::PARTIAL
        assert @trade.order.open_qty == @trade.order.quantity - @trade.counterparty_order.quantity
        
    end

end
  