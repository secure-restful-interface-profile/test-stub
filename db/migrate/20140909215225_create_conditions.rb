class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :text_status
      t.string :text
      t.string :system
      t.string :code
      t.string :code_text
    	t.string :identifier_use
      t.string :identifier_label
      t.string :identifier_system
      t.string :identifier_value
      t.string :subject_reference
      t.string :subject_text
      t.string :encounter_reference
      t.string :encounter_text
      t.string :asserter_reference
      t.string :asserter_text
      t.date :date_asserted
      t.string :category_system
      t.string :category_code
      t.string :category_text
      t.string :status
      t.string :certainty_system
      t.string :certainty_code
      t.string :certainty_text
      t.string :severity_system
      t.string :severity_code
      t.string :severity_text
      t.date :onset_date
      t.string :onset_age_value
      t.string :onset_age_units
      t.string :onset_age_system
      t.string :onset_age_code
      t.boolean :abated
      t.date :abatement_date
      t.string :abatement_age_value
      t.string :abatement_age_units
      t.string :abatement_age_system
      t.string :abatement_age_code
      t.string :stage_system
      t.string :stage_code
      t.string :stage_text
      t.string :assessment_reference
      t.string :assessment_text
      t.string :evidence_system
      t.string :evidence_code
      t.string :evidence_text
      t.string :detail_reference
      t.string :detail_text
      t.string :location_system
      t.string :location_code
      t.string :location_text
      t.string :location_detail
      t.string :related_item_fhir_type
      t.string :related_item_system
      t.string :related_item_code
      t.string :related_item_text
      t.string :target_reference
      t.string :target_text
      t.string :notes

      t.timestamps
    end
  end
end
