class Order < ApplicationRecord
    
    validates   :user_id, :symbol, :security_id, :order_type, :side, 
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

    before_create do
        self.status ||= OPEN 
        self.open_qty ||= self.quantity
        self.fill_status ||= NOT_FILLED 
    end
    
    before_save do 
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
                
                # Create the trade
                trade = Trade.create(order_id: self.id, symbol: self.symbol,
                    security_id: self.security_id, quantity: quantity,
                    price: counterparty_order.price, buyer_id: self.user_id,
                    seller_id: counterparty_order.user_id, 
                    counterparty_order_id: counterparty_order.id)
                
                    # Update the orders
                self.filled_qty = quantity
                self.save

                counterparty_order.filled_qty = quantity
                counterparty_order.save
            end

            return true
        else
            return false
        end
    end

end
