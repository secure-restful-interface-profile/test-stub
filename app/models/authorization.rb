##
# = Authorization Model
#
# This model provides a many-to-many relationship between patients and authorized 
# users and is used to keep track of what authorized users have access to which 
# patients.

class Authorization < ActiveRecord::Base

  belongs_to  :patient
  belongs_to  :authorized_user

end
