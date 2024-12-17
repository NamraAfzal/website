require 'rails_helper'

RSpec.describe Sellers::ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:seller) { create(:seller,email: "seller@example.com") }
  let(:product) { create(:product, seller: seller) }

  before do
    sign_in seller
  end

  describe 'GET #new' do
    it 'assigns a new Product to @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested product to @product' do
      get :show, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'POST #create' do
    context 'with invalid attributes' do
      it 'does not create a product and re-renders the new template' do
        product_params = attributes_for(:product, name: nil)
        expect {
          post :create, params: { product: product_params }
        }.not_to change(seller.products, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested product to @product' do
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the product and redirects to the product path' do
        patch :update, params: { id: product.id, product: { name: 'Updated Name' } }
        product.reload
        expect(product.name).to eq('Updated Name')
        expect(response).to redirect_to(sellers_product_path(product))
        expect(flash[:notice]).to eq("Product updated successfully.")
      end
    end

    context 'with invalid attributes' do
      it 'does not update the product and re-renders the edit template' do
        product
        patch :update, params: { id: product.id, product: { name: nil } }
        expect(product.reload.name).not_to be_nil
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the product and redirects to index' do
      product
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(seller.products, :count).by(-1)
      expect(response).to redirect_to(sellers_products_path)
      expect(flash[:notice]).to eq("Product deleted successfully.")
    end
  end


  describe 'Private Methods' do
    describe '#set_product' do
      it 'finds the product associated with the seller' do
        sign_in seller
        controller.params = ActionController::Parameters.new(id: product.id)
        controller.send(:set_product)
        expect(assigns(:product)).to eq(product)
      end
    end


    describe '#product_params' do
      it 'permits the correct attributes' do
        allow(controller).to receive(:params).and_return(
          ActionController::Parameters.new(
            product: {
              name: 'sample product',
              description: 'A sample product description',
              price: 100,
              category_id: 1,
              stock: 10,
            }
          )
        )
        permitted_params = controller.send(:product_params)
        expect(permitted_params.keys.map(&:to_sym)).to match_array(%i[name description price category_id stock])
      end
    end
  end
end
