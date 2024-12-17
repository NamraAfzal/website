require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order) { create(:order, status: :placed, user: user) }
  let(:user) { create(:user,email: 'test@example.com') }
  let(:seller) { create(:seller) }
  let(:category) { create(:category) }
  let(:product) { create(:product,name: 'Laptop', price: 20.0, description: 'A great laptop', stock: 10, seller: seller, category: category) }
  let(:order_item) { create(:order_item, order: order, product: product, quantity: 2) }

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

  it 'has ransackable attributes' do
    expect(OrderItem.ransackable_attributes).to include('id', 'order_id', 'product_id', 'quantity', 'created_at', 'updated_at')
  end

  it 'has ransackable associations' do
    expect(OrderItem.ransackable_associations).to include('order', 'product')
  end
end
