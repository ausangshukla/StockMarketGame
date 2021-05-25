class Trade < ApplicationRecord
    validates   :order_id, :symbol, :security_id, :quantity, :price, 
                :buyer_id, :seller_id, presence: true

    belongs_to :user
    belongs_to :security
    belongs_to :order
    belongs_to :counter_party_order, class_name: "Order"
end
