##
# = AuthorizationServer model
#
# This class manages the interface to the Authorization Server.

class AuthorizationServer

  attr_accessor   :uri, :connection, :configuration

  #-------------------------------------------------------------------------------
 
  ##
  # This method initializes a new instance of the AuthorizationServer class and
  # sets up the necessary configurations for the communicating with the server.
  #
  # Params:
  #   +auth_server_uri+::   URI of the authorization server
  #   +rsrc_server_uri+::   URI of protected resource server
  #
  # Attributes set:
  #   +@uri+::              URI of the authorization server
  #   +@connection+::       Connection object to be used for further communication
  #   +@configuration+::    Hash of server capabilities and endpoints

  def initialize(auth_server_uri, rsrc_server_uri)
    @auth_server_uri = auth_server_uri
    @rsrc_server_uri = rsrc_server_uri

    Rails.logger.debug "========== @auth_server_uri = " + @auth_server_uri + "=========="
    Rails.logger.debug "========== @rsrc_server_uri = " + @rsrc_server_uri + "=========="

    # Establish a connection object that will be reused during communication 
    # with the authorization server

    @connection = Faraday.new(@auth_uri, :ssl => {:verify => false}) do |builder|
      builder.request     :url_encoded    # Encode request parameters as "www-form-urlencoded"
      builder.response    :logger         # Log request and response to STDOUT
      builder.adapter     :net_http       # Perform requests with Net::HTTP
    end

    # Get authorization server endpoints and configuration settings
    response = @connection.get("#{@auth_server_uri}/.well-known/openid-configuration")
    @configuration = JSON.parse(response.body)
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method retrieves the public key for the authorization server from the 
  # authorization server's jwks_uri endpoint.
  #
  # Returns:
  #   +String+::            Public key for Authorization Server

  def public_key
    # The public key is provided as a JSON Web Key Set (JWKS) by the jwks_uri 
    # endpoint of the Authorization Server.

    response = @connection.get(@configuration["jwks_uri"])
    jwks = JSON.parse(response.body)

    # Use only first key returned and retrieve the "n" field of that key
    jwks["keys"].first["n"]
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method determines whether the access token provided by the client is valid.
  # To validate the token, the introspection endpoint of the authorization server
  # is called to retrieve the claims for the access token.  Once we have the claims,
  # we can validate whether data request falls within those claims.
  #
  # Params:
  #   +client_request+::    Request hash from the client requesting information
  #
  # Returns:  
  #   +boolean+::           +true+ if access allowed, otherwise +false+

  def authorize_request(client_request, test = false)
    #access_token = Application.test_access_token
    access_token = "eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE0MTY1MTc3MTcsImF1ZCI6WyJlOTg0OWNmMS0wZGUyLTRiMzYtYWMzNy1hYjk1M2Q3OGM3Y2YiXSwiaXNzIjoiaHR0cHM6XC9cL2FzLXZhLm1pdHJlLm9yZ1wvIiwianRpIjoiZTVlZWQzMjYtNjljZC00NjFhLTk4MzYtYzJiMjhkN2I5NTkwIiwiaWF0IjoxNDE2NTE0MTE3fQ.VDhPLYosO_CovfBWBXHVuZk9kX0_znfh1v5ZuHaKCHnzhwM2qfLext400Ac9pIpnbNwYNGT0FnGKoqB1mrRFrfuzp5kbtc__o1N1VNEHm-EM03eGjiNGRnBA0hf2TPidQKi7H0oCr1G3jxZmZ373eIz838_gjew2Ia5KpdwMov5PaejYvyvaEGkjOhcb63phsfQPyDKRmGZkTLYRdHMCZL3j6UesFeZrSJaS5NQk0mzzR-fFPKIEyXOKhCi5zogEFiWNq08wSiiSXh_JB58sY_fdbNrItwSml80pR1CQprQftIurubcYVz6TwNKxhcTf7etOWSFPe0ewGwr7riCfdA"

    # Get access token from client request
    # authorization = client_request.env["HTTP_AUTHORIZATION"]
    # Rails.logger.debug "--------- authorization = #{authorization} ----------"

    # if authorization
    #   authorization = authorization.split(' ')
    #   if authorization.first == 'Bearer'
    #     access_token = authorization.last
    #   end

      Rails.logger.debug "********** Request = #{client_request.inspect} **********"
      Rails.logger.debug "////////// Access token = #{access_token.inspect} //////////"

      # Call authorization server to perform introspection on access token
      auth_response = @connection.post @configuration["introspection_endpoint"] do |request|
        # Pass access token as form data
        request.body = { 
          "client_id"             => Application.client_id, 
          "client_assertion_type" => "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
          "client_assertion"      => jwt_token, 
          "token"                 => access_token 
        }.to_param

        Rails.logger.debug "--------- request.headers = " + request.headers.inspect + " ----------"
        Rails.logger.debug "--------- request.body = " + request.body.inspect + " ---------"
      end

      Rails.logger.debug "--------- auth_response = " + auth_response.inspect + " ----------"
      #Rails.logger.debug "--------- auth_response['valid'] = " + auth_response["valid"] + " ----------"
      Rails.logger.debug "--------- auth_response.body = " + auth_response.body + " ----------"

      if test
        return auth_response
      else
        # Use introspection info to determine validity of access token for request
        valid_access_token?(client_request, auth_response)
      end
    # else
    #   # No access token
    #   false
    # end
  end

  #-------------------------------------------------------------------------------
  private
  #-------------------------------------------------------------------------------

  ##
  # This method creates a JSON Web Token (JWT) so that we can authenticate with
  # the authorization server.
  #
  # Returns:
  #   ++::                  Signed JSON Web Token

  def jwt_token
    # Sign our claims with our private key.  The authorization server will 
    # contact our jwks_uri endpoint to get our public key to decode the JWT.

    JWT.encode(jwt_claims, Application.private_key, 'RS256')
  end

  #-------------------------------------------------------------------------------

  CLAIM_EXPIRATION = 3600         # Expiration in seconds

  ##
  # This method defines the claims for the JSON Web Token (JWT) we use to
  # authenticate with the authorization server.
  #
  # Returns:
  #   +Hash+::              Set of claims for JSON Web Token

  def jwt_claims
    now = Time.now.to_i

    {
      iss: Application.client_id,                   # Issuer (Resource Server)
      sub: Application.client_id,                   # Subject of request (Resource Server)
      aud: "https://as-va.mitre.org/token",         # Intended audience (Authorization Server)
      iat: now,                                     # Time of issue
      exp: now + CLAIM_EXPIRATION,                  # Expiration time
      jti: "#{now}/#{SecureRandom.hex(18)}",        # Unique ID for request
    }
  end

  #-------------------------------------------------------------------------------

  ##
  # This method validates the access token passed to us by the client by checking
  # the type of information allowed by the access token and and verifying that the 
  # request is consistent with those claims.
  #
  # Params:
  #   +client_request+::    Original request from the client seeking access
  #   +auth_response+::     Response from the Authorization Server introspection
  #
  # Returns:  
  #   +boolean+::           +true+ if access allowed, otherwise +false+

  def valid_access_token?(client_request, auth_response)
    byebug
    if result = (auth_response.status == 200)
      token_claims = JSON.parse(auth_response.body)

      # Authorize request based on claims of access token
      result &&= token_claims["active"]
      result &&= validate_expiration(token_claims)              if result
      result &&= validate_scope(client_request, token_claims)   if result
    end

    Rails.logger.debug "----- valid_access_token? = #{result.to_s} -----"
    result
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method determines whether the access token has expired.
  #
  # Params:
  #   +token_claims+::      Claims from access token introspection
  #
  # Returns:
  #   +boolean+::           +true+ if token has not expired, otherwise +false+

  def validate_expiration(token_claims)
    byebug
    if token_claims["exp"].blank?
      Rails.logger.debug "----- no expiration time provided in access token -----"
      # No expiration time provided
      true
    else
      Rails.logger.debug "----- token_claims['exp'] = #{token_claims["expires_at"].inspect} -----"
      expiration_time = Time.parse(token_claims["exp"])
      (expiration_time >= Time.now)
    end
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method determines whether the access token has expired.
  #
  # Params:
  #   +client_request+::    Original request from the client seeking access
  #   +token_claims+::      Claims from access token introspection
  #
  # Returns:
  #   +boolean+::           +true+ if request within token scope, otherwise +false+

  def validate_scope(client_request, token_claims)
    byebug
    claims = token_claims["scope"].split(' ')

    Rails.logger.debug "----- claims = #{claims.inspect} -----"
    uri = URI(client_request.uri)

    # Remove initial '/' from path to get resource name
    resource = uri.path.from(1)
    Rails.logger.debug "----- resource = #{resource.inspect} -----"

    claims.include?(resource)
  end

end
