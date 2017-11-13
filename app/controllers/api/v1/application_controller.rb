class Api::V1::ApplicationController < ApplicationController
  include Authenticable

  # before_action :authenticate!
end
