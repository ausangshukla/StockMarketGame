class Order < ApplicationRecord
    validates   :user_id, :symbol, :security_id, :order_type, :side, 
                :quantity, :price_type, :order_type, :status, presence: true

    ORDER_TYPES = ["Normal", "Short", "Short Cover"]
    SIDE_TYPES = ["B", "S"]
    PRICE_TYPES =["Market", "Limit"]
    STATUS = [  "Open", "Modified", "Cancelled", "Partially Filled", "Filled", 
                "Partially Filled and Cancelled"]
end
