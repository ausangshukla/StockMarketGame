# When a new order is created then a Block statement reserves the money required
# When trades occur then no funds are affected in the user account
# For market trades, if the trade amount is greater than the blocked amount, then we will block some more funds
# When an order is cancelled, then funds are returned to the user account minus any partially executed trades
# End of the day all Open orders are cancelled
class Statement < ApplicationRecord
    
    TYPES = ["From Bank", "To Bank", "Trade", "Block"]
    

    belongs_to :ref, polymorphic: true

    # Called when an order is placed
    def self.debitOrderAmount(order)
        Statement.transaction do
            s = Statement.create(stmt_type: "Block", debit: order.block_amount,
                    user_id: order.user_id, ref: order,
                    particulars: "Blocked for creating order #{order.id}")

            self.user.blockFunds(s.debit)
        end
    end

    # Called when an order is cancelled
    def self.creditOrderAmount(order)

        # How much to unblock ? That depends on the cost of trades
        trade_amount = order.trades.inject(0){|sum, t| sum + t.amount}
        if order.block_amount > trade_amount
            unblock_amount = order.block_amount - trade_amount 
            Statement.transaction do
                s = Statement.create(stmt_type: "UnBlock", credit: order.block_amount,
                        user_id: order.user_id, ref: order,
                        particulars: "UnBlocked for cancelling order #{order.id}")

                self.user.unblockFunds(s.credit)
            end                
        end
    end

    def eodStatement(user_id)

    end


end
