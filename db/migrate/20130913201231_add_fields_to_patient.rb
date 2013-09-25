class AddFieldsToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :familyname, :string
    add_column :patients, :textname, :string
  end
end
