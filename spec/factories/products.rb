FactoryBot.define do
  factory :product do
    name { Faker::Commerce.unique.product_name }
    price { 100 }
    description { 'A sample product description' }
    stock { 10 }
    association :seller
    association :category
  end
end
# FactoryBot.define do
#   factory :product do
#     name { Faker::Commerce.unique.product_name }
#     price { Faker::Commerce.price(range: 50.0..500.0) }
#     description { Faker::Lorem.sentence(word_count: 10) }
#     stock { Faker::Number.between(from: 1, to: 100) }
#     association :seller
#     association :category
#   end
# end
