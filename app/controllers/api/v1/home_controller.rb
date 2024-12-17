module Api
  module V1
    class HomeController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_default_response_format

      def index
        render json: { message: 'Welcome to the API', status: 200 }, status: :ok
      end

      private

      def set_default_response_format
        request.format = :json
      end
    end
  end
end
