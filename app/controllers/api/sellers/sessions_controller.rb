module Api
  module Sellers
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        if resource
          sign_in(resource_name, resource)
          token = request.env['warden-jwt_auth.token']
          render json: {
            message: 'Logged in successfully',
            user: resource,
            token: token
          }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        if current_seller
          sign_out(resource_name)
          render json: { message: 'Logged out successfully' }, status: :ok
        else
          render json: { error: 'No active session found' }, status: :unauthorized
        end
      end

      private

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end
