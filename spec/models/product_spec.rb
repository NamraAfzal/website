require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:category) { Category.create!(name: 'Electronics') }
  let(:seller) { Seller.create!(email: "seller@example.com",password: "password123" ) }
  let(:product) { Product.new(name: 'Laptop', price: 1000.0, description: 'A great laptop', stock: 10, seller: seller, category: category) }
  it 'is valid with a name, price, description, stock, seller, and category' do
    product = Product.new(name: 'Laptop', price: 1000, description: 'A great laptop', stock: 10, seller: seller, category: category)
    expect(product).to be_valid
  end

  it 'is invalid without a name' do
    product.name = nil
    expect(product).to be_invalid
    expect(product.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a price' do
    product.price = nil
    expect(product).to be_invalid
    expect(product.errors[:price]).to include("can't be blank")
  end

  it 'is invalid without a description' do
    product.description = nil
    expect(product).to be_invalid
    expect(product.errors[:description]).to include("can't be blank")
  end

  it 'is invalid without stock' do
    product.stock = nil
    expect(product).to be_invalid
    expect(product.errors[:stock]).to include("can't be blank")
  end

  it 'is invalid with non-integer stock' do
    product.stock = 10.5
    expect(product).to be_invalid
    expect(product.errors[:stock]).to include("must be an integer")
  end


  it 'is invalid with a negative stock' do
    product.stock = -5
    expect(product).to be_invalid
    expect(product.errors[:stock]).to include("must be greater than or equal to 0")
  end

  it 'is invalid without a seller' do
    product.seller = nil
    expect(product).to be_invalid
    expect(product.errors[:seller]).to include("must exist")
  end

  it 'is invalid without a category' do
    product.category = nil
    expect(product).to be_invalid
    expect(product.errors[:category]).to include("must exist")
  end

  it 'is valid with an image attached' do
    file = Rails.root.join('spec', 'support' , 'fixtures', 'files', 'test_image.png')
    image = fixture_file_upload(file, 'image/png')
    product.image.attach(image)
    expect(product).to be_valid
  end

  it 'calculates total sales correctly' do
    user = User.create!(email: 'test@example.com', password: '123456@')
    seller = Seller.create!(email: 'test@example.com', password: '123456@')
    category = Category.create!(name: 'Electronics')
    product = Product.create!(name: 'Laptop', price: 1000.0, description: 'A great laptop', stock: 10, seller: seller, category: category)

    order = Order.create!(status: :placed, user: user)
    order_item = OrderItem.create!(order: order, product: product, quantity: 3)

    expect(product.total_sales).to eq(3)
  end

  it 'has ransackable attributes' do
    expect(Product.ransackable_attributes).to include('id', 'name', 'price', 'created_at', 'updated_at')
  end

  it 'has ransackable associations' do
    expect(Product.ransackable_associations).to include('category', 'image_attachments', 'image_blobs', 'order_items', 'orders', 'seller')
  end
end
