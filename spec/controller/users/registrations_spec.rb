require 'rails_helper'

describe Users::RegistrationsController, type: :controller do
  describe "#sign_up_params" do
    controller do
      def test_sign_up_params
        render json: sign_up_params
      end
    end

    before do
      Rails.application.routes.draw do
        post 'test_sign_up_params', to: "users/registrations#test_sign_up_params"
      end
    end

    after do
      Rails.application.reload_routes!
    end

    let(:valid_params) do
      {
        user: {
          email: "test@example.com",
          name: "Test User",
          password: "password123",
          password_confirmation: "password123",
          address: "123 Test Street"
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: "test@example.com",
          name: "Test User",
          password: "password123",
          password_confirmation: "password123",
          extra_param: "not permitted"
        }
      }
    end

    it "permits valid parameters" do
      post :test_sign_up_params, params: valid_params
      expect(response.body).to include_json(
        email: "test@example.com",
        name: "Test User",
        password: "password123",
        password_confirmation: "password123",
        address: "123 Test Street"
      )
    end

    it "does not permit additional parameters" do
      post :test_sign_up_params, params: invalid_params
      expect(response.body).not_to include_json(
        extra_param: "not permitted"
      )
    end
  end
end
