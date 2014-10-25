class TestController < ActionController::Base

  def index
    server = AuthorizationServer.new("https://as-va.mitre.org", "https://ehr-va.mitre.org")
    server.authorize_request(request)

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

end
