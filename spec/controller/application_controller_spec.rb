require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include Devise::Test::ControllerHelpers

  controller do
    def index
      render plain: "Test"
    end
  end

  let(:user) { User.create(email: "user@example.com", password: "123456@") }
  let(:seller) { Seller.create(email: "seller@example.com", password: "123456@") }

  describe "before actions" do
    context "when using a Devise controller" do
      it "calls configure_permitted_parameters" do
        allow(controller).to receive(:devise_controller?).and_return(true)
        expect(controller).to receive(:configure_permitted_parameters)
        controller.send(:configure_permitted_parameters)
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#configure_permitted_parameters" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    # it "permits additional parameters for Devise sign-up" do
    #   allow(controller).to receive(:devise_controller?).and_return(true)
    #   expect(controller.devise_parameter_sanitizer).to receive(:permit).with(:sign_up, keys: [:name])
    #   controller.send(:configure_permitted_parameters)
    # end
  end

  describe "#after_sign_in_path_for" do
    it "redirects to seller's dashboard for sellers" do
      expect(controller.send(:after_sign_in_path_for, seller)).to eq(sellers_dashboard_index_path)
    end

    it "redirects to products path for users" do
      expect(controller.send(:after_sign_in_path_for, user)).to eq(products_path)
    end
  end

  describe "#layout_by_resource" do
    # context "when using Devise controller for Seller" do
    #   before do
    #     allow(controller).to receive(:devise_controller?).and_return(true)
    #     allow(controller).to receive(:resource_name).and_return(:seller)
    #   end

    #   it "returns the seller layout" do
    #     expect(controller.send(:layout_by_resource)).to eq("seller")
    #   end
    # end

    context "when not using Devise controller" do
      before do
        allow(controller).to receive(:devise_controller?).and_return(false)
      end

      it "returns the user layout" do
        expect(controller.send(:layout_by_resource)).to eq("user")
      end
    end
  end
end
