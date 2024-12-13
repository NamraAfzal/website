require 'rails_helper'
RSpec.describe OrderItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:order) { create(:order, user:, status: :cart) }
  let(:order_item) { create(:order_item, order:, product:, quantity: 1) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "when adding a new product to the cart" do
      it "creates a new order item and redirects to the product page with a success notice" do
        post :create, params: { product_id: product.id, quantity: 2 }
        expect(order.order_items.count).to eq(1)
        expect(order.order_items.first.quantity).to eq(2)
        expect(response).to redirect_to(product_path(product))
        expect(flash[:notice]).to eq("#{product.name} added to your cart.")
      end
    end

    context "when adding an existing product to the cart" do
      before { order_item }

      it "increments the quantity of the existing order item" do
        post :create, params: { product_id: product.id }

        expect(order_item.reload.quantity).to eq(2)
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
        expect(response).to redirect_to(order_path)
        expect(flash[:notice]).to eq('Cart updated successfully.')
      end
    end
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
    order
  end

  describe "Private methods" do
    describe "#set_order" do
      it "finds or creates a cart order for the current user" do
        controller.instance_eval { set_order }
        expect(assigns(:order)).to eq(order)
      end
    end
    describe "#set_order_item" do
      it "finds the order item by id" do
        get :destroy, params: { id: order_item.id }
        expect(assigns(:order_item)).to eq(order_item)
      end
    end
  end
end
