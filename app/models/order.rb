class Order < ApplicationRecord
    
    validates   :user_id, :security_id, :order_type, :side, 
                :quantity, :price_type, :order_type, presence: true

    ORDER_TYPES = ["Normal", "Short", "Short Cover"]
    SIDE_TYPES = ["B", "S"]
    PRICE_TYPES =["Market", "Limit"]
    STATUS = [  "Open", "Cancelled" ]
    FILL_STATUS = ["Filled", "Partially Filled", "Not Filled"]

    scope :open, -> { where(status: OPEN) }

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
        self.price = 0 if self.price_type == Order::MARKET
        if self.open_qty == 0
            self.fill_status = FILLED
        elsif self.open_qty < self.quantity
            self.fill_status = PARTIAL
        elsif self.open_qty == self.quantity
            self.fill_status = NOT_FILLED
        end

    end

    
    
    def block_amount
        trade_price = self.price_type == LIMIT ? self.price : security.price 
        trade_price * quantity        
    end

    def to_s
        "Id: #{self.id}, Side: #{self.side}, Type: #{self.price_type}, Status: #{self.status} #{self.fill_status}, Open: #{self.open_qty}, Filled: #{self.filled_qty}" 
    end
end
