module Api
  module V1
    class UsersController < RestController
      before_action :authenticate_admin!

      def destroy
        super do |user|
          if user == current_user
            render json: { error: 'Not authorized' }, status: :unauthorized
            return
          end
        end
      end

      private

      def resource_params
        params.fetch(:user).permit(
          :name, :email, :password, :password_confirmation, :role
        )
      end
    end
  end
end
