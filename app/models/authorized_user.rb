##
# = Authorized User Model
#
# This model manages the list of authorized users that can access patient
# records within the system.  The authorized user model contains a user ID
# administered from the authorization server.

class AuthorizedUser < ActiveRecord::Base

  has_many  :authorizations
  has_many  :patients, :through => :authorizations

end
