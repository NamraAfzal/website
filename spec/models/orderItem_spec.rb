require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order) { Order.create!(status: :placed, user: User.create!(email: 'test@example.com', password: '123456@')) }
  let(:product) { Product.create!(name: 'Laptop', price: 1000.0, description: 'A great laptop', stock: 10, seller: Seller.create!(email: 'test@example.com', password: '123456@'), category: Category.create!(name: 'Electronics')) }
  let(:order_item) { OrderItem.new(order: order, product: product, quantity: 2) }

  it 'is valid with a quantity greater than 0' do
    order_item.quantity = 2
    expect(order_item).to be_valid
  end

  it 'is invalid with a quantity less than or equal to 0' do
    order_item.quantity = 0
    expect(order_item).to be_invalid
    expect(order_item.errors[:quantity]).to include('must be greater than 0')

    order_item.quantity = -1
    expect(order_item).to be_invalid
    expect(order_item.errors[:quantity]).to include('must be greater than 0')
  end

  it 'is invalid without a quantity' do
    order_item.quantity = nil
    expect(order_item).to be_invalid
    expect(order_item.errors[:quantity]).to include("can't be blank")
  end

  # Test ransackable attributes
  it 'has ransackable attributes' do
    expect(OrderItem.ransackable_attributes).to include('id', 'order_id', 'product_id', 'quantity', 'created_at', 'updated_at')
  end

  # Test ransackable associations
  it 'has ransackable associations' do
    expect(OrderItem.ransackable_associations).to include('order', 'product')
  end
end
