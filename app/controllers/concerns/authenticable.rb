module Authenticable
  def authenticate_admin!
    return if current_user.role_name == 'admin'
    not_authorized
  end

  def authenticate_agent!
    return if %w[agent admin].include?(current_user.role_name)
    not_authorized
  end

  def authenticate_customer!
    return if %w[customer admin].include?(current_user.role_name)
    not_authorized
  end

  private

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
