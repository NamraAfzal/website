FactoryBot.define do
  factory :product do
    name { 'sample product' }
    price { 100.0 }
    description { 'A sample product description' }
    stock { 10 }
    association :seller
    association :category
    # after(:create) do |product|
    #   product.image.attach(io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'image.png')), filename: 'image.png', content_type: 'image/png')
    # end
  end
end
