class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  protected

  AUTHENTICATION_TOKEN = 'fake_token'.freeze

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      token == AUTHENTICATION_TOKEN
    end
  end

  def render_unauthorized(realm = 'Application')
    self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: {errors: ['Unauthorized access'] }, status: :unauthorized
  end
end
