class Position < ApplicationRecord
    belongs_to :user
    belongs_to :security

    def avgBuyPrice
        buy_trades = self.user.trades.where(security_id: self.security_id, side: Order::BUY)
        count = buy_trades.count
        amount = buy_trades.inject(0.0){|sum, t| sum + t.amount}
        amount / count
    end

    def self.add(trade)


        position = trade.user.positions.where(security_id: trade.security_id).first 
        position ||= Position.new(  user_id: trade.user_id, 
                                    security_id: trade.security_id, 
                                    symbol: trade.security.symbol, 
                                    quantity: 0, average_cost: 0, 
                                    current_value: 0, eod_value: 0 )

        if trade.side == Order::BUY
            position.quantity += trade.quantity
            position.average_cost += position.avgBuyPrice()
            position.current_value = position.quantity * trade.security.price
        else
            position.quantity -= trade.quantity
            position.current_value = position.quantity * trade.security.price
        end

        position.save
    end

    def trades 
        self.user.trades.where(security_id: self.security_id).includes(:user)
    end
end
