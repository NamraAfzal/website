module Api
  module V1
    module Users
      class Users::RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, options={})
          if resource.persisted?
            render json: {
              status: { code: 200,message: 'Signed up successfully',
                data: resource }
            }, status: :ok
          else
            render json: {
              status: {message: 'User could not be created successfull',
              errors: resource.error.full_messages }, status: :unprocessable_entity
            }
          end
        end
      end
    end
  end
end
