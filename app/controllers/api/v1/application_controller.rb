module Api
  module V1
    class ApplicationController < ::ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Authenticable

      alias authenticate_user! authenticate_api_v1_user!
      alias current_user current_api_v1_user

      respond_to :json

      before_action :authenticate_user!

      def index
        { version: 1 }
      end
    end
  end
end
