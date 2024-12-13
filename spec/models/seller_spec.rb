require 'rails_helper'
RSpec.describe Seller, type: :model do

  describe "instance methods" do
    let(:seller) { create(:seller) }
    let(:category) { Category.create!(name: 'Electronics') }
    let(:product1) { create(:product, seller: seller, price: 10.0) }
    let(:product2) { Product.create!(name: 'Laptop', price: 20.0, description: 'A great laptop', stock: 10, seller: seller, category: category) }
    let(:order1) { create(:order) }
    let(:order2) { create(:order) }
    let!(:order_item1) { create(:order_item, product: product1, order: order1, quantity: 2) }
    let!(:order_item2) { create(:order_item, product: product2, order: order1, quantity: 3) }
    let!(:order_item3) { create(:order_item, product: product1, order: order2, quantity: 1) }

    describe "associations" do
      it { should have_many(:products) }
      it { should have_many(:orders).through(:products) }
    end

    describe "validations" do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_presence_of(:password) }
    end

    describe "#total_orders" do
      it "returns the total number of distinct orders for the seller's products" do
        expect(seller.total_orders).to eq(2)
      end
    end

    describe "#total_products" do
      it "returns the total number of products owned by the seller" do
        expect(seller.total_products).to eq(2)
      end
    end

    describe "#total_sales" do
      it "returns the total quantity of items sold across all orders" do
        expect(seller.total_sales).to eq(6) # 2 + 3 + 1
      end
    end

    describe "#total_revenue" do
      it "returns the total revenue from all sales" do
        expected_revenue = (2 * 10.0) + (3 * 20.0) + (1 * 10.0)
        expect(seller.total_revenue).to eq(expected_revenue)
      end
    end
  end
end
