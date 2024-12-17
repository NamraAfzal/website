require 'rails_helper'

RSpec.describe Sellers::OrdersController, type: :controller do
  let(:seller) { create(:seller) }
  let(:product) { create(:product, seller:) }
  let(:order) { create(:order) }
  let!(:order_item) { create(:order_item, order:, product:) }

  before do
    sign_in seller
  end

  describe "GET #index" do
    it "assigns @orders and renders the index template" do
      get :index
      expect(assigns(:orders)).to match_array([order])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "when the order exists" do
      it "assigns @selected_order and renders the show template" do
        get :show, params: { id: order.id }
        expect(assigns(:selected_order)).to eq(order)
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET #edit" do
    it "assigns @order and renders the edit template" do
      get :edit, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "when update is successful" do
      it "updates the order status and redirects with a notice" do
        patch :update, params: { id: order.id, order: { status: "shipped" } }
        expect(order.reload.status).to eq("shipped")
        expect(response).to redirect_to(sellers_order_path)
        expect(flash[:notice]).to eq("Order status updated successfully.")
      end
    end

    context "when update fails" do
      it "does not update the order and redirects with a failure notice" do
        allow_any_instance_of(Order).to receive(:update).and_return(false)
        patch :update, params: { id: order.id, order: { status: "completed" } }
        expect(order.reload.status).not_to eq("completed")
        expect(response).to redirect_to(sellers_order_path)
        expect(flash[:notice]).to eq("Failed to update order status.")
      end
    end
  end
end
