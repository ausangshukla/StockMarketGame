class Order < ApplicationRecord
    
    validates   :user_id, :security_id, :order_type, :side, 
                :quantity, :price_type, :order_type, presence: true

    ORDER_TYPES = ["Normal", "Short", "Short Cover"]
    SIDE_TYPES = ["B", "S"]
    PRICE_TYPES =["Market", "Limit"]
    STATUS = [  "Open", "Cancelled" ]
    FILL_STATUS = ["Filled", "Partially Filled", "Not Filled"]


    BUY = "B"
    SELL = "S"

    LIMIT = "Limit"
    MARKET = "Market"
    
    FILLED = "Filled"
    NOT_FILLED = "Not Filled"
    PARTIAL = "Partally Filled"
    
    OPEN = "Open"
    CANCELLED = "Cancelled"
    
    belongs_to :user
    belongs_to :security
    has_many :trades

    before_save do 

        self.status ||= OPEN 
        self.open_qty ||= self.quantity
        self.filled_qty ||= 0
        self.fill_status ||= NOT_FILLED 
        self.symbol ||= Security.find(security_id).symbol

        self.open_qty = self.quantity - self.filled_qty
        if self.open_qty == 0
            self.fill_status = FILLED
        elsif self.open_qty < self.quantity
            self.fill_status = PARTIAL
        elsif self.open_qty == self.quantity
            self.fill_status = NOT_FILLED
        end
    end

    scope :open, -> { where(status: OPEN) }

    # Cross this order with the input order
    def cross(counterparty_order)
        # ensure the right sides
        if(self.side != counterparty_order.side)
            
            quantity = (self.quantity <= counterparty_order.quantity) ? self.quantity : counterparty_order.quantity

            Trade.transaction do
                
                buyer_id = self.side == BUY ? self.user_id : counterparty_order.user_id
                seller_id = self.side == SELL ? self.user_id : counterparty_order.user_id
                
                # Create the trade
                trade = Trade.new(order_id: self.id, symbol: self.symbol,
                    security_id: self.security_id, quantity: quantity,
                    price: counterparty_order.price, 
                    buyer_id: buyer_id,
                    seller_id: seller_id, 
                    counterparty_order_id: counterparty_order.id)
                trade.save
                
                # Update the orders
                self.filled_qty = quantity
                self.save

                counterparty_order.filled_qty = quantity
                counterparty_order.save
            end

            return true
        else
            logger.debug "Orders not on opposite side"
            return false
        end
    end

end
