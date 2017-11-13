module Api
  module V1
    class SessionsController < ApplicationController
      respond_to :json

      skip_before_action :authenticate_with_token!, only: %i[create destroy]

      def create
        user = User.find_by(email: session_params[:email])

        if user&.valid_password?(session_params[:password])
          sign_in user, store: false
          user.generate_auth_token!
          render json: user, status: :ok
        else
          msg = 'Invalid email or password'
          render json: { error: msg }, status: :unauthorized
        end
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        user.try(:remove_auth_token!)
        head :no_content
      end

      private

      def session_params
        params.fetch(:session).permit(:email, :password)
      end
    end
  end
end
