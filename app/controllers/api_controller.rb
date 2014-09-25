class ApiController < ApplicationController

  before_filter   :authorize_request

  def index
    @objects = current_model.where(patient_id: params[:patient_id])

    respond_to do |format|
      format.json { render json: @objects }
      format.xml { render xml: @objects }
    end
  end

  def show
    @object = current_model.find(params[:id])

    respond_to do |format|
      format.json { render json: @object }
      format.xml { render xml: @object }
    end
  end

  private

  def authorize_request
    true
  end

  def current_model
    Object.const_get(params[:model].classify)
  end

end
