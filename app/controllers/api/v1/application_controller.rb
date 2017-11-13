module Api
  module V1
    class ApplicationController < ActionController::API
      include Authenticable

      respond_to :json

      before_action :authenticate_with_token!
    end
  end
end
