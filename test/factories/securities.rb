FactoryBot.define do
  factory :security do
    sec_type { Security::SEC_TYPES[rand(2)] }
    symbol { ('a'..'z').to_a.shuffle[0,4].join.upcase }
    name { Faker::Company.name }
    prev_closing_price { rand(20) * 1.4 + 10 }
    opening_trade_price { rand(20) * 1.4 + 10}
    day_high_price { rand(20) * 1.4 + 20 }
    day_low_price { day_high_price - 10 }
    price { rand(20) * 1.4 }
    market_cap { rand(20) * 100000 }
    pe { rand(20) + 10 }
    last_trade_date { Time.now }
  end
end
