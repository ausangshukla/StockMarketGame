FactoryBot.define do
  factory :order do
    side { Order::SIDE_TYPES[rand(2)] }
    quantity { rand(20) + rand(10) }
    price { rand(20) * 1.5 }
    price_type { Order::PRICE_TYPES[rand(2)] }
    order_type { "Normal" }
    qualifier {  }
    status { "Open" }
  end
end
