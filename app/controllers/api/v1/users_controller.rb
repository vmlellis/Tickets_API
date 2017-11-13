class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
    # TODO
  end

  def show
    user = User.find(params[:id])
    respond_with user
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    # TODO
  end

  def update
  end
end
