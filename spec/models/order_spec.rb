require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user,email: 'test@example.com') }
  let(:seller) { create(:seller,email: 'test@example.com') }
  let(:category) { create(:category) }
  let(:product) { create(:product,name: 'Laptop', price: 1000.0, description: 'A great laptop', stock: 10, seller: seller, category: category) }
  let(:order) { create(:order,user: user) }

  it 'is valid with a user and a status' do
    order.status = :cart
    expect(order).to be_valid
  end

  it 'is invalid without a status' do
    order.status = nil
    expect(order).to be_invalid
    expect(order.errors[:status]).to include("can't be blank")
  end

  it 'is invalid without a user' do
    order.user = nil
    expect(order).to be_invalid
    expect(order.errors[:user]).to include("must exist")
  end

  it 'has valid statuses' do
    expect(Order.statuses.keys).to include('cart', 'placed', 'confirmed', 'shipped')
  end

  it 'sets default status to cart on creation' do
    order.save!
    expect(order.status).to eq('cart')
  end

  it 'destroys associated order_items when destroyed' do
    order.save!
    order_item = OrderItem.create!(order: order, product: product, quantity: 2)
    expect { order.destroy }.to change { OrderItem.count }.by(-1)
  end

  it 'has products through order_items' do
    order.save!
    OrderItem.create!(order: order, product: product, quantity: 2)
    expect(order.products).to include(product)
  end

  it 'has ransackable attributes' do
    expect(Order.ransackable_attributes).to include('id', 'status', 'created_at', 'updated_at', 'user_id')
  end

  it 'has ransackable associations' do
    expect(Order.ransackable_associations).to include('order_items', 'user')
  end

  describe '.for_seller' do
    it 'returns orders for a specific seller' do
      order.save!
      create(:order_item,order: order, product: product, quantity: 2)
      expect(Order.for_seller(seller)).to include(order)
    end

    it 'does not return orders for other sellers' do
      other_seller = create(:seller,email: "user@example.com")
      other_product = create(:product,name: 'Phone', price: 500.0, description: 'A great phone', stock: 5, seller: other_seller, category: category)
      order.save!
      create(:order_item,order: order, product: other_product, quantity: 1)
      expect(Order.for_seller(seller)).not_to include(order)
    end
  end
end
