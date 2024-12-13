require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:category) { create(:category) }
  let!(:products) { create_list(:product, 5, category: category) }

  describe "GET #index" do
    context "without category filter" do
      it "returns all products" do
        get :index, params: {}
        expect(assigns(:products).count).to eq(Product.count)
        expect(response).to render_template(:index)
      end

      it "returns paginated products" do
        get :index, params: { page: 1, per_page: 5 }
        expect(assigns(:products).size).to eq(5)
        expect(response).to render_template(:index)
      end

      it "filters products based on search parameters" do
        get :index, params: { q: { name_cont: products.first.name } }
        expect(assigns(:products)).to include(products.first)
      end
    end

    context "with category filter" do
      it "returns products from the specified category" do
        get :index, params: { category: category.id }
        expect(assigns(:products)).to match_array(products)
      end

      it "filters products within the specified category based on search parameters" do
        get :index, params: { category: category.id, q: { name_cont: products.first.name } }
        expect(assigns(:products)).to include(products.first)
        expect(assigns(:products).count).to eq(1)
      end
    end
  end

  describe "GET #show" do
    context "when the product exists" do
      it "assigns the requested product" do
        get :show, params: { id: products.first.id }
        expect(assigns(:product)).to eq(products.first)
        expect(response).to render_template(:show)
      end
    end

    context "when the product does not exist" do
      it "raises an ActiveRecord::RecordNotFound error" do
        expect { get :show, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
