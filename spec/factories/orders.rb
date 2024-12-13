FactoryBot.define do
  factory :order do
    status { :cart }
    user_id { 1 }
    shipping_address { "lahore" }
    association :user
    association :order_items
    association :products
  end
end
