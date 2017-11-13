class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  # before_action :authenticate

  def index
    render json: { status: 'ok' }
  end

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @current_user = authenticate_with_http_token do |token, _|
      User.find_by(token: token)
    end
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { error: 'Bad credentials' }, status: :unauthorized
  end

  def render_resource_error(resource)
    name = resource.class.name.underscore
    msg = []
    resource.errors.messages.each do |key, errors|
      errors.each { |error| msg << "#{name}[#{key}] #{error}" }
    end
    render json: { error: msg.join(', ') }, status: :bad_request
  end

  def render_not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
