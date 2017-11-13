class SessionsController < ApplicationController
  # skip_before_action :authenticate, only: [:create]
  before_action :validate_presence, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: { token: user.load_token, user: user.to_json }, status: :ok
    else
      msg = 'incorrect email or password'
      render json: msg, status: :unauthorized
    end
  end

  private

  def validate_presence
    return if params[:email].present? && params[:password].present?
    msg = "#{params[:email].blank? ? 'email' : 'password'} is required"
    render json: msg, status: :bad_request
  end
end
