module AuthHelper
  def auth_header(user)
    { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password) }
  end
end
