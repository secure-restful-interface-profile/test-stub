##
# = JSON Web Key Set (JWKS) Controller
#
# This class manages the jwks_uri API for the Test Stub

class JwksController < ApplicationController

  ## 
  # GET /jwks
  #
  # This method is used by the authorization server to retrieve the public key
  # of the test stub.  
  # 
  # The /jwks API is generally called when a JSON Web Token (JWT), signed by the 
  # Test Stub's private key, is sent by the Test Stub to the authorization server 
  # for authentication.  The authorization server uses the public key returned
  # by this API call to decode and authenticate the JWT.
  #
  # The public key is returned as a JWK Set using the following
  # format:
  #
  # {"keys":
  #   [
  #     {"kty":"RSA",
  #      "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx
  #             4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMs
  #             tn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2
  #             QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbI
  #             SD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqb
  #             w0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw",
  #      "e":"AQAB",
  #      "alg":"RS256",
  #      "kid":"2011-04-29"}
  #   ]
  # }
  #
  # Return:
  #   +JSON+::                JWK set containing public key for the Test Stub

  def index
    Rails.logger.debug "========= Call to /jwks endpoint =========="

    # Build JWK set from test stub's public key
    jwks = { 
      keys: [{
        kty:  "RSA", 
        n:    UrlSafeBase64.encode64(Application.public_key.n.to_s(2)), 
        e:    UrlSafeBase64.encode64(Application.public_key.e.to_s(2)),
        alg:  "RS256",
        kid:  "rsa1"
      }]
    }

    #jwks = JSON::JWK.new(Application.public_key)
    render json: jwks
  end

end
