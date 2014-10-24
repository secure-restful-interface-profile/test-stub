##
# = API Controller
#
# This class manages the resource API for the Test Stub.

class ApiController < ApplicationController

  before_filter   :verify_access_token

  #-------------------------------------------------------------------------------

  ##
  # This method retrieves a collection of the requested resources that match the
  # specified parameters.
  #
  # Params (from URI request):
  #   +model+::               Type of resources requested
  #   +patient_id+::          Patient associated with the requested resources
  #
  # Returns:
  #   List of resources in XML or JSON format.

  def index
    if Patient == current_model
      @objects = current_model.all
    else
      @objects = current_model.where(patient_id: params[:patient_id])
    end

    respond_to do |format|
      format.json { render json: @objects }
      format.xml  { render xml: @objects }
    end
  end

  #-------------------------------------------------------------------------------

  ##
  # This method retrieves the requested resource matching the specified parameters.
  #
  # Params:
  #   +model+::               Type of resource requested
  #   +id+::                  Resource identifier
  #
  # Returns:
  #   List of resources in XML or JSON format.

  def show
    @object = current_model.find(params[:id])

    respond_to do |format|
      format.json { render json: @object }
      format.xml  { render xml: @object }
    end
  end

  #-------------------------------------------------------------------------------
  private
  #-------------------------------------------------------------------------------

  ##
  # This method verifies the OAuth2 access token with the Authorization Server.
  #
  # Returns:
  #   +boolean+::           +true+ if access allowed, otherwise +false+

  def verify_access_token
    @server ||= AuthorizationServer.new(Application.authorization_server,
                                          Application.resource_server)
    head :unauthorized unless @server.authorize_request(request)
  end

  #-------------------------------------------------------------------------------
 
  ##
  # This method retrieves the current model being requested by the client.
  #
  # Params (from URI request):
  #   +model+::               Type of resources requested
  #
  # Returns:
  #   +Class+::             Class of the model requested by the client.

  def current_model
    Object.const_get(params[:model].classify)
  end

end
