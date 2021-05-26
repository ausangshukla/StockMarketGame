FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }
      email { Faker::Internet.email }
      password {email}
      role {"User"}
      available_margin {10**10}
      available_cash { available_margin }
      opening_balance { available_margin }
  end
end
