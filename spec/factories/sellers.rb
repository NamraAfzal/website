FactoryBot.define do
  factory :seller do
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    company_name { "Company Inc." }
    store_url { "https://example.com/store" }
    association :order
  end
end
