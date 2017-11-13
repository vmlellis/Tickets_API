module Authenticable
  def current_user
    @current_user ||= begin
      authorization = request.headers['Authorization']
      return nil unless authorization.present?
      User.find_by(auth_token: authorization)
    end
  end

  def authenticate_with_token!
    return if current_user
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  User::ROLES.each do |role|
    define_method("authenticate_#{role}!") do
      return if [role, 'admin'].include?(current_user.role_name)
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
