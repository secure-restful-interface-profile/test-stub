class TestController < ActionController::Base

  def index
    server = AuthorizationServer.new("https://as-va.mitre.org", "https://ehr-va.mitre.org")
    @response = server.authorize_request(nil, true)
  end

end
