class Api::V1::SessionsController < ApplicationController
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

  private

  def session_params
    params.fetch(:session).permit(:email, :password)
  end
end
