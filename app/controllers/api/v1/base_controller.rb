module Api
  module V1
    class BaseController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Authenticable

      respond_to :json

      before_action :authenticate_with_token!
    end
  end
end
