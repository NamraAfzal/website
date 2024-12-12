require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe '#sign_up_params' do
    controller(Devise::RegistrationsController) do
      def sign_up_params
        params.require(:user).permit(:email, :name, :password, :password_confirmation, :address)
      end
    end

    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          name: 'Test User',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Test St.'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: 'test@example.com',
          name: 'Test User',
          password: 'password123',
          password_confirmation: 'password123',
          address: '123 Test St.',
          admin: true
        }
      }
    end

    before do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new(valid_params))
    end

    it 'permits the expected parameters' do
      permitted_params = controller.sign_up_params
      expect(permitted_params.keys.map(&:to_sym)).to contain_exactly(:email, :name, :password, :password_confirmation, :address)
    end

    it 'does not include unexpected parameters' do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new(invalid_params))
      permitted_params = controller.sign_up_params

      expect(permitted_params.keys.map(&:to_sym)).not_to include(:admin)
    end

    it 'raises an error if :user is missing' do
      expect do
        controller.params.require(:missing_user_key)
      end.to raise_error(ActionController::ParameterMissing)
    end
  end
end
