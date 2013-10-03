class Patient < ActiveRecord::Base
  has_many :encounters
  has_many :observations
  
  rails_admin do 
    field :givenname do
      label "Given Name"
    end
    field :familyname do
      label "Family Name"
    end
    field :gender do
      label "Gender"
    end
    field :birthdate do
      label "Birth Date"
    end
    field :telecom do
      label "Primary Contact Value (phone/email)"
    end
    field :address do
      label "Address"
    end
    field :isdeceased do
      label "Is Deceased?"
    end
    field :maritalstatus do
      label "Marital Status"
    end
    field :outsidecontact do
      label "Outside Contact Name"
    end
    field :outsidecontacttelecom do
      label "Outside Contact Value (phone/email)"
    end
    field :outsidecontactaddress do
      label "Outside Contact Address"
    end
    field :primarylanguage do
      label "Primary Language"
    end
    field :active do
      label "Active"
    end
    field :created_at do
      label "Created On"
    end
    field :updated_at do
      label "Updated On"
    end

    edit do
      field :created_at do
        hide
      end
      field :updated_at do
        hide
      end
      field :encounters
      field :observations
    end
  end
end
