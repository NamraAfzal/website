FactoryBot.define do
  factory :product do
    name { Faker::Commerce.unique.product_name }
    price { 100 }
    description { 'A sample product description' }
    stock { 10 }
    association :seller
    association :category
    association :order_items
    association :orders
  end
end
