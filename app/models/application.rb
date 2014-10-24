##
# = AuthorizationServer model
#
# This class manages the OAuth attributes for the application.

class Application

	##
	#

  def self.public_key
    OpenSSL::PKey::RSA.new(File.read("./config/server.pub"))
  end

  #-------------------------------------------------------------------------------
 
	##
	#
	
  def self.private_key
    OpenSSL::PKey::RSA.new(File.read("./config/server.key"))
  end

  #-------------------------------------------------------------------------------

	##
	#
	
  def self.certificate
    File.read("./config/server.crt")
  end

  #-------------------------------------------------------------------------------

	##
	#
	
  def self.client_id
  	File.read("./config/client.id")
  end

  #-------------------------------------------------------------------------------

	##
	#
	
  def self.resource_server
  	File.read("./config/resource_server")
  end

  #-------------------------------------------------------------------------------

	##
	#
	
  def self.authorization_server
  	File.read("./config/authorization_server")
  end

end
