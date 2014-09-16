class Observation < ActiveRecord::Base
  belongs_to  :patient
  belongs_to  :encounter
  
  rails_admin do 
    field :name do
      label "Name"
    end
    field :obs_type do
      label "Observation Type"
    end
    field :value do
      label "Value"
    end
    field :interpretation do
      label "Interpretation"
    end
    field :comments do
      label "Comments"
    end
    field :issued do
      label "Observation Issued (date/time)"
    end
    field :period do
      label "Observation Period"
    end
    field :status do
      label "Status"
    end
    field :reliability do
      label "Reliability"
    end
    field :bodysite do
      label "Body Site"
    end
    field :methodcode do
      label "Method Code"
    end
    field :methodtext do
      label "Method Text"
    end
    field :performer do
      label "Performer"
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
    end
  end
end
