module Api
  module V1
    class UserController < BaseController
      def show
        respond_with current_user
      end

      def update
        user = current_user
        if user.update(user_params)
          render json: user, status: :ok
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.fetch(:user).permit(:name, :password, :password_confirmation)
      end
    end
  end
end
