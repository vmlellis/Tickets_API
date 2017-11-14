module Authenticable
  User::ROLES.each do |role|
    define_method("authenticate_#{role}!") do
      return if [role, 'admin'].include?(current_user.role_name)
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
