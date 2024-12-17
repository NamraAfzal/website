require 'rails_helper'

RSpec.describe Sellers::DashboardController, type: :controller do
  let!(:seller) { create(:seller) }
  let!(:category) { create(:category, name: 'Electronics') }
  let!(:product1) { create(:product, seller:) }
  let!(:product2) { create(:product,name: 'Laptop', price: 20.0, description: 'A great laptop', stock: 10, seller: seller, category: category) }
  let!(:order1) { create(:order) }
  let!(:order2) { create(:order) }
  let!(:order_item1) { create(:order_item, product: product1, order: order1, quantity: 2) }
  let!(:order_item2) { create(:order_item, product: product2, order: order2, quantity: 1) }

  before do
    sign_in seller
  end

  describe "GET #index" do
    it "assigns @products with the seller's products" do
      get :index
      expect(assigns(:products)).to match_array([product1, product2])
    end

    it "assigns @total_products with the count of seller's products" do
      get :index
      expect(seller.total_products).to eq(2)
    end

    it "assigns @total_orders with the count of orders containing the seller's products" do
      get :index
      expect(assigns(:total_orders)).to eq(2)
    end

    it "assigns @total_sales with the total revenue from the seller's products" do
      get :index
      total_sales = (order_item1.quantity * product1.price) + (order_item2.quantity * product2.price)
      expect(assigns(:total_sales)).to eq(total_sales)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
