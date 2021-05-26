class Trade < ApplicationRecord
    validates   :buy_order_id, :sell_order_id, :symbol, :security_id, 
                :quantity, :price, 
                :buyer_id, :seller_id, presence: true

    belongs_to :buyer, class_name: "User"
    belongs_to :seller, class_name: "User"
    belongs_to :security
    belongs_to :buy_order, class_name: "Order"
    belongs_to :sell_order, class_name: "Order"


    before_create do        
        logger.debug "Saving price #{price} for Security #{security.symbol}"
        security.price = self.price 
        security.save
    end

    def amount
        price * quantity
    end
end
