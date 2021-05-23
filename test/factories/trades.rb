FactoryBot.define do
  factory :trade do
    order_id { 1 }
    symbol { "MyString" }
    quantity { 1 }
    price { 1.5 }
    buyer_id { 1 }
    seller_id { 1 }
  end
end
