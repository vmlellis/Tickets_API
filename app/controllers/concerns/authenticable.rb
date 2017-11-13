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
end
