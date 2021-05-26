FactoryBot.define do
  factory :order do
    side { Order::SIDE_TYPES[rand(2)] }
    quantity { rand(20) + rand(10) }
    price_type { Order::PRICE_TYPES[rand(2)] }
    price {  side == "B" ? rand(10) + 10 : rand(20) * 10 + 30 }
    order_type { "Normal" }
    qualifier {  }
    status { "Open" }
  end
end
