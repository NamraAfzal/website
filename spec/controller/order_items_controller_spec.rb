require 'rails_helper'
RSpec.describe OrderItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, seller:) }
  let(:order) { create(:order) }
  let(:order_item) { create(:order_item, order:, product:) }
  let(:seller) { create(:seller) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "when adding a new product to the cart" do
      before { order_item }
      it "creates a new order item and redirects to the product page with a success notice" do
        post :create, params: { product_id: product.id }
        expect(order.order_items.count).to eq(1)
        expect(response).to redirect_to(product_path(product))
        expect(flash[:notice]).to eq("#{product.name} added to your cart.")
      end
    end

    context "when save fails" do
      it "redirects with an alert" do
        allow_any_instance_of(OrderItem).to receive(:save).and_return(false)

        post :create, params: { product_id: product.id }

        expect(response).to redirect_to(product_path(product))
        expect(flash[:alert]).to eq("Failed to add product to cart.")
      end
    end
  end

  describe "DELETE #destroy" do
    before { order_item }

    it "removes the order item and redirects to the order path with a success notice" do
      delete :destroy, params: { id: order_item.id }

      expect(order.order_items.count).to eq(0)
      expect(response).to redirect_to(order_path)
      expect(flash[:notice]).to eq('Product removed from cart.')
    end
  end

  describe "PATCH #update_quantity" do
    before { order_item }

    context "when increasing the quantity" do
      it "increments the quantity of the order item and redirects with a success notice" do
        patch :update_quantity, params: { id: order_item.id, operation: "increase" }
        expect(order_item.reload.quantity).to eq(2)
        expect(response).to redirect_to(order_path)
        expect(flash[:notice]).to eq('Cart updated successfully.')
      end
    end

    context "when decreasing the quantity" do
      it "decrements the quantity of the order item if greater than 1" do
        order_item.update!(quantity: 2)

        patch :update_quantity, params: { id: order_item.id, operation: "decrease" }
        expect(order_item.reload.quantity).to eq(1)
        expect(flash[:notice]).to eq('Cart updated successfully.')
      end
    end
  end

  describe "Private methods" do
    it "#set_order_item finds the order item by id" do
      allow(controller).to receive(:params).and_return({ id: order_item.id })
      expect(controller.send(:set_order_item)).to eq(order_item)
    end
    it "finds the order item by id" do
      get :destroy, params: { id: order_item.id }
      expect(assigns(:order_item)).to eq(order_item)
    end
  end
end
