class Trade < ApplicationRecord
    validates   :order_id, :counterparty_order_id, :symbol, :security_id, 
                :quantity, :price, 
                :buyer_id, :seller_id, presence: true

    belongs_to :buyer, class_name: "User"
    belongs_to :seller, class_name: "User"
    belongs_to :security
    belongs_to :order
    belongs_to :counterparty_order, class_name: "Order"


    before_save do
        security.price = self.price 
        security.save
    end
end
