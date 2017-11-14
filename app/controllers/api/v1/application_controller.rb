module Api
  module V1
    class ApplicationController < ::ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Authenticable

      alias_method :authenticate_user!, :authenticate_api_v1_user!
      alias_method :current_user, :current_api_v1_user

      respond_to :json

      before_action :authenticate_user!
    end
  end
end
