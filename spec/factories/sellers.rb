FactoryBot.define do
  factory :seller do
    email { Faker::Internet.unique.email }
    password { "123456@" }
    password_confirmation { "123456@" }
    company_name { "Company Inc." }
    store_url { "https://example.com/store" }
  end
end
