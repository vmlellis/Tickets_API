module Api
  module V1
    class UsersController < RestController
      before_action :authenticate_admin!

      private

      def resource_params
        params.fetch(:user).permit(
          :name, :email, :password, :password_confirmation, :role
        )
      end
    end
  end
end
