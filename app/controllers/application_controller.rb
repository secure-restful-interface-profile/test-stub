##
# = Application Controller
#
# This is the base controller class for the Test Stub application.

class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #-------------------------------------------------------------------------------
 
  # def oauth_client
  # 	@client ||= OAuth2::Client.new(OAUTH_PROVIDER_ID, OAUTH_PROVIDER_SECRET, :site => OAUTH_PROVIDER_URL)
  # end

  #-------------------------------------------------------------------------------
 
  # def oauth_access_token
  # 	@token ||= OAuth2::AccessToken.new(oauth_client, current_user.access_token) if current_user
  # end

end
