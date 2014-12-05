##
# = Application Controller
#
# This is the base controller class for the Test Stub application.  The Test Stub 
# is meant to provide a mock representation of an EHR system or service for 
# application development and testing purposes.
#
# In later development or production, this Test Stub would be replaced by the 
# actual EHR system or health related service.

class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

end
