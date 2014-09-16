class AddPatientIdToMedicationsConditions < ActiveRecord::Migration
  def change
  	add_column	:medications, :patient_id, :integer
  	add_column	:conditions, :patient_id, :integer
  end
end
