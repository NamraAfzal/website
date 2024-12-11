FactoryBot.define do
  factory :seller do
    email { "seller@example.com" }
    password { "password123" }  # Add a password to satisfy validation
    password_confirmation { "password123" }  # If you have a confirmation field
    company_name { "Company Inc." }
    store_url { "https://example.com/store" }
  end
end
