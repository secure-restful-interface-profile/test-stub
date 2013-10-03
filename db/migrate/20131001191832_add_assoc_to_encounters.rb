class AddAssocToEncounters < ActiveRecord::Migration
  def change
    change_table :encounters do |t|
      t.belongs_to :patient
    end
  end
end
