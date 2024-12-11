FactoryBot.define do
  factory :order do
    status { :cart }
    user_id { 1 }
    shipping_address { "lahore" }
    association :user
  end
end
