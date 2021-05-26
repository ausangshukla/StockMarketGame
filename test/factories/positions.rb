FactoryBot.define do
  factory :position do
    name { "MyString" }
    user_id { 1 }
    security_id { 1 }
    symbol { "MyString" }
    quantity { 1 }
    average_cost { 1.5 }
    current_value { 1.5 }
    eod_value { 1.5 }
  end
end
