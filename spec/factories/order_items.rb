FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    association :order
    association :product
  end
end
