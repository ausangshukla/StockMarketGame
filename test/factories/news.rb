FactoryBot.define do
  factory :news do
    news_type { News::TYPES[rand(3)] }
    details { Faker::Lorem.paragraphs(5).join() }
  end
end
