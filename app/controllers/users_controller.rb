class UsersController < ApplicationController
  before_action :admin_permission
  before_action :validate_presence_user, only: %i[create update]

  def index
    render json: { users: User.all.map(&:to_json) }, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: { user: user.to_json }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def create
    user = User.new(resource_params)
    if user.save
      render json: { id: user.id }, status: :created
    else
      render_resource_error(user)
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(resource_params)
      head :ok
    else
      render_resource_error(user)
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :ok
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  private

  def admin_permission
    return if current_user.admin?
    render_unauthorized
  end

  def resource_params
    params.fetch(:user).permit(:name, :email, :password, :role)
  end

  def validate_presence_user
    return if params.key?(:user)
    render json: { error: 'User is required' }, status: :bad_request
  end
end
