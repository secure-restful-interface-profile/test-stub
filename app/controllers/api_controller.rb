##
# = API Controller
#
# This class manages the resource API for the Test Stub.  The Test Stub API is 
# meant to provide a mock representation of an API for an EHR system or service 
# for application development and testing purposes.
#
# In later development or production, this Test Stub would be replaced by the 
# actual EHR system or health related service.

class ApiController < ApplicationController

  before_filter   :verify_access_token

  #-------------------------------------------------------------------------------

  ##
  # GET /[model].xml
  # GET /[model].json
  # GET /[model]?patient=[patient_id].xml
  # GET /[model]?patient=[patient_id].json
  #
  # Retrieves a collection of the requested resources that match the
  # specified parameters.
  #
  # Params (from URI request):
  #   +model+::               Type of resources requested
  #   +patient+::             Patient associated with the requested resources
  #
  # Returns:
  #   List of resources in XML or JSON format.

  def index
    if Patient == current_model
      Rails.logger.debug "--- Looking up top-level patient info ---"
      @objects = @authorized_user.patients
    elsif params[:patient]
      Rails.logger.debug "--- Patient specified in request ---"
      head :unauthorized and return unless can_access_patient?(params[:patient])
      
      @objects = current_model.where(patient_id: params[:patient])
    else
      Rails.logger.debug "--- Patient implied ---"
      head :bad_request and return unless patient_implicit?
      
      @objects = current_model.where(patient_id: @authorized_user.patients.first)
    end

    respond_to do |format|
      format.json { render json: @objects }
      format.xml  { render xml: @objects }
    end
  end

  #-------------------------------------------------------------------------------

  ##
  # GET /[model]/[id].xml
  # GET /[model]/[id].json
  #
  # Retrieves the requested resource matching the specified parameters.
  #
  # Params:
  #   +model+::               Type of resource requested
  #   +id+::                  Resource identifier
  #
  # Returns:
  #   List of resources in XML or JSON format.

  def show
    if Patient == current_model
      Rails.logger.debug "--- Looking up top-level patient info ---"
      head :unauthorized and return unless can_access_patient?(params[:id])

      @object = current_model.find(params[:id])
    else
      Rails.logger.debug "--- Patient implied ---"
      head :bad_request and return unless patient_implicit?
      @object = current_model.find(params[:id])

      head :unauthorized and return unless can_access_patient?(@object.patient_id)
    end

    respond_to do |format|
      format.json { render json: @object }
      format.xml  { render xml: @object }
    end
  end

  #-------------------------------------------------------------------------------
  private
  #-------------------------------------------------------------------------------

  ##
  # Validates the OAuth2 access token with the Authorization Server.  This is  
  # a Rails filter routine that is called before executing the actual request.
  #
  # This routine only performs the application-independent portion of determining
  # whether the access token is valid.  Access token scopes are handled opaquely
  # by the underlying logic, so they can remain application independent.
  #
  # The application-specific portions of the authorization (what authorized users 
  # can do with specific resources morely finely defined than scopes by application) 
  # are handled in the public methods of this controller.
  #
  # Returns:
  #   Unauthorized 401 if the access token is invalid.
  #   Forbidden 403 if no matching authorized user is found.
  #   Otherwise, the authorized user identified and validated in the access token 
  #   is returned in the @authorized_user instance variable.

  def verify_access_token
    Rails.logger.debug "====== request.headers['Authorization'] = #{request.headers['Authorization']} ======"

    server = AuthorizationServer.new(Application.authorization_server,
                                          Application.resource_server)

    result, @authorized_user = server.authorize_request(request)
    Rails.logger.debug "------ authorized_user = #{@authorized_user.inspect} ------"

    # If the result is OK, proceed with the operation
    head result unless result == :ok
  end

  #-------------------------------------------------------------------------------
 
  ##
  # Retrieves the current model being requested by the client.
  #
  # Params (from URI request):
  #   +model+::             Type of resources requested
  #
  # Returns:
  #   +Class+::             Class of the model requested by the client.

  def current_model
    Object.const_get(params[:model].classify)
  end

  #-------------------------------------------------------------------------------
 
  ##
  # Determines whether the authorized user can access the specified patient's 
  # records.
  #
  # Params:
  #   +patient_id+::        ID of patient record in database
  #
  # Returns:
  #   +Boolean+::           +true+ if access allowed, otherwise +false+
  #

  def can_access_patient?(patient_id)
    @authorized_user.patients.map { |patient| patient.id }.include?(patient_id.to_i)
  end

  #-------------------------------------------------------------------------------
 
  ##
  # Determines whether the patient can be implied from the request.  If the 
  # authorized user can only access one patient, that patient is implied.
  #
  # Returns:
  #   +Boolean+::           +true+ if patient can be determined, otherwise +false+

  def patient_implicit?
    @authorized_user.patients.size == 1  
  end

end
