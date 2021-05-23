class Trade < ApplicationRecord
    validates   :order_id, :symbol, :security_id, :quantity, :price, 
                :buyer_id, :seller_id, presence: true
end
