class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Authenticable

  def index
    render json: { status: 'ok' }
  end
end
