class Encounter < ActiveRecord::Base
  belongs_to  :patient
  has_many    :observations

  rails_admin do 
    field :patient_id do
      label "Patient ID"
    end
    field :status do
      label "Status"
    end
    field :enc_class do
      label "Encounter Class"
    end
    field :enc_type do
      label "Encounter Type"
    end
    field :participant do
      label "Participant (Practitioner)"
    end
    field :participanttype do
      label "Participant Type (Attending/Consulting/etc.)"
    end
    field :start do
      label "Encounter Start Time"
    end
    field :length do
      label "Encounter Length"
    end
    field :priority do
      label "Priority"
    end
    field :location do
      label "Encounter Location"
    end
    field :locationperiod do
      label "Location Period"
    end
    field :serviceprovider do
      label "Service Provider (Department or Team providing care)"
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
      field :observations
    end
  end
end
