require 'rails_helper'
RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user, status: :cart) }
  let!(:order_item) { create(:order_item, order: order, quantity: 2, product: create(:product, price: 10.0)) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns user's non-cart orders to @orders" do
      non_cart_order = create(:order, user: user, status: :placed)
      get :index
      expect(assigns(:orders)).to eq([non_cart_order])
    end
  end

  describe "GET #show" do
    it "assigns the requested order's items to @order_items" do
      get :show, params: { id: order.id }
      expect(assigns(:order_items)).to eq(order.order_items)
    end
  end

  describe "PATCH #place_order" do
    context "with valid address and order items" do
      it "updates the user's address and places the order" do
        patch :place_order, params: { id: order.id, address: "123 Test St" }
        order.reload
        expect(order.shipping_address).to eq("123 Test St")
        expect(response).to redirect_to(payment_order_path(order))
      end
    end

    context "with no order items" do
      before { order.order_items.destroy_all }
      it "redirects to the order path with an alert" do
        patch :place_order, params: { id: order.id, address: "123 Test St" }
        expect(response).to redirect_to(order_path(order.id))
        expect(flash[:alert]).to eq("Your cart is empty. Cannot place order.")
      end
    end
  end

  describe "POST #checkout" do
    it "handles a successful payment" do
      allow_any_instance_of(StripeService).to receive(:find_or_create_order).and_return(double(id: "stripe_user_id"))
      allow_any_instance_of(StripeService).to receive(:create_stripe_customer_card).and_return(double(id: "card_id"))
      allow_any_instance_of(StripeService).to receive(:create_stripe_charge).and_return(double(id: "charge_id"))

      post :checkout, params: { id: order.id, card_number: "4242424242424242", cvc: "123", exp_month: "12", exp_year: "2030" }

      order.reload
      expect(order.status).to eq("placed")
      expect(order.stripe_transaction_id).to eq("charge_id")
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq("Payment has been successfully completed.")
    end

    it "handles a Stripe card error" do
      allow_any_instance_of(StripeService).to receive(:create_stripe_charge).and_raise(Stripe::CardError.new("Card declined", nil))

      post :checkout, params: { id: order.id, card_number: "4242424242424242", cvc: "123", exp_month: "12", exp_year: "2030" }

      expect(response).to redirect_to(order_items_path)
      expect(flash[:alert]).to eq("Payment failed: Card declined")
    end

    it "handles a Stripe error" do
      allow_any_instance_of(StripeService).to receive(:create_stripe_charge).and_raise(Stripe::StripeError.new("API error"))

      post :checkout, params: { id: order.id, card_number: "4242424242424242", cvc: "123", exp_month: "12", exp_year: "2030" }

      expect(response).to redirect_to(order_items_path)
      expect(flash[:alert]).to eq("Payment processing error: API error")
    end

    it "handles stock reduction failure" do
      order_item.product.update(stock: 1)

      post :checkout, params: { id: order.id, card_number: "4242424242424242", cvc: "123", exp_month: "12", exp_year: "2030" }

      expect(response).to redirect_to(order_items_path)
      expect(flash[:alert]).to eq("Payment processing error: Amount must be at least $0.50 usd")
    end
  end

  describe "private methods" do
    describe "#set_cart_order" do
      it "redirects if no cart order exists" do
        order.update(status: :placed)
        get :show, params: { id: order.id }
        expect(response).to redirect_to(order_path)
        expect(flash[:alert]).to eq("No active cart found.")
      end
    end
  end
end
