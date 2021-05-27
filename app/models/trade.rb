class Trade < ApplicationRecord
    validates   :order_id, :counterparty_order_id, :symbol, :security_id, 
                :quantity, :price, 
                :user_id, presence: true

    belongs_to :user
    belongs_to :security
    belongs_to :order
    belongs_to :counterparty_order, class_name: "Order"


    before_create do        
        logger.debug "Saving price #{price} for Security #{security.symbol}"
        security.price = self.price 
        security.save
    end

    after_create do
        Position.add(self)
    end

    after_save do
        broadcast()
    end
 
     
    def amount
        price * quantity
    end
end
