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
    byebug
    @auth_server_uri = auth_server_uri
    @rsrc_server_uri = rsrc_server_uri

    # Establish a connection object that will be reused during communication 
    # with the authorization server

    @connection = Faraday.new(@auth_uri, :ssl => {:verify => false})

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

  def authorize_request(client_request)
    byebug
    # Get access token from client request
    #access_token = client_request.env["omniauth.auth"]
    access_token = "eyJhbGciOiJSUzI1NiJ9.eyJleHAiOjE0MTQyMjUxNTksImF1ZCI6WyJjbGllbnQiXSwiaXNzIjoiaHR0cHM6XC9cL2FzLXZhLm1pdHJlLm9yZ1wvIiwianRpIjoiOTRjYWNjNGEtMTQ5NC00MDE0LTkyMTEtNmIxZDViODBiOTQ5IiwiaWF0IjoxNDE0MTgxOTU5fQ.PGQSiZiO6sAvM5kpIdelxy-gtESJzSRrQ-hYfunIVl0BIeCRA0Fm4FII5LEZ92Tiq-nJckfgJVS5HdqxmtUh7db-FAt4MvkvhEBMhIOW-ePbNuOHjTPHQgORIF1BoXqqMC_BV6H4H0UVKRtoWxuk8qh4cAwXprVEcuDBwqcN5AhweW0WoFcEppdyjrTd99g3b6LV7FQJT5xjUIBCdbfG-3C01l8jDHkhKISPKfufa2mJvzxYgHkcIgeftK3xL5BcluixYOF7Pz_Chry2zLekZ5sFkoPtxdektWED_Ws7aFjSaB9FZNM_SOrcEOtwQLcrkCENkEEIjcdP8o5Hxgd2NQ"

    # Call authorization server to perform introspection on access token
    auth_response = @connection.post do |request|
      request.url(@configuration["introspection_endpoint"])

      request.headers["Content-type"]    = "application/x-www-form-urlencoded"
      request.headers["Accept"]          = "application/json"
      request.headers["Authorization"]   = "JWT " + jwt_token
      request.params["token"]            = access_token
    end
    byebug

    # Use introspection info to determine validity of access token for request
    valid_access_token?(client_request, auth_response)
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

  CLAIM_EXPIRATION = 60         # Expiration in seconds

  ##
  # This method defines the claims for the JSON Web Token (JWT) we use to
  # authenticate with the authorization server.
  #
  # Returns:
  #   +Hash+::              Set of claims for JSON Web Token

  def jwt_claims
    now = Time.now.to_i

    {
      iss: @rsrc_server_uri,                  # Issuer (Resource Server)
      aud: @auth_server_uri,                  # Intended audience (Authorization Server)
      azp: Application.client_id,             # Client ID given to us from 
                                              #    authorization server
      sub: @rsrc_server_uri,                  # Subject of request (Resource Server)
      iat: now,                               # Time of issue
      exp: now + CLAIM_EXPIRATION,            # Expiration time (60 seconds from now)
      jti: "#{now}/#{SecureRandom.hex(18)}",  # Unique ID for request
    }
  end

  #-------------------------------------------------------------------------------

  ##
  # This method validates the access token passed to us by the client.  We use
  # the introspection endpoint of the Authorization Server to determine the claims
  # for the type of information allowed by the access token and verify that the 
  # request is consistent with those claims.
  #
  # Params:
  #   +client_request+::    Original request from the client seeking access
  #   +auth_response+::     Response from the Authorization Server introspection
  #
  # Returns:  
  #   +boolean+::           +true+ if access allowed, otherwise +false+

  def valid_access_token?(client_request, auth_response)
    if result = (auth_response["valid"] == "true")
      token_claims = auth_response.body

      # Authorize request based on claims of access token
      result &&= validate_expiration(auth_response)
      result &&= validate_audience(client_request, token_claims) if result
      result &&= validate_scope(client_request, token_claims) if result
    end

    result
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method determines whether the access token has expired.
  #
  # Params:
  #   +auth_response+::     Response from the Authorization Server introspection
  #
  # Returns:
  #   +boolean+::           +true+ if token has not expired, otherwise +false+

  def validate_expiration(auth_response)
    if auth_response["expires_at"].blank?
      # No expiration time provided
      true
    else
      (auth_response["expires_at"].to_i >= Time.now.to_i)
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
  #   +boolean+::           +true+ if request matches token audience, otherwise +false+

  def validate_audience(client_request, token_claims)
    true  # for now...  not sure what to do with this yet...
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
    claims = token_claims.split[' ']
    uri = URI(client_request.uri)

    # Remove initial '/' from path to get resource name
    resource = uri.path.from(1)

    claims.include?(resource)
  end

end
