class AddAssocToObs < ActiveRecord::Migration
  def change
    change_table :observations do |t|
      t.belongs_to :patient
      t.belongs_to :encounter
    end
  end
end
