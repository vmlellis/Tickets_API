module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_action :configure_sign_up_params, only: [:create]
        before_action :configure_account_update_params, only: [:update]

        def create
          super
        end

        def update
          super
        end

        private

        def sign_up_params
          super.merge(role: 'customer')
        end

        def configure_sign_up_params
          devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
        end

        def configure_account_update_params
          devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
        end
      end
    end
  end
end
