class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :givenname
      t.string :familyname
      t.string :gender
      t.string :birthdate
      t.string :telecom
      t.string :address
      t.boolean :isdeceased
      t.string :maritalstatus
      t.string :outsidecontact
      t.string :outsidecontacttelecom
      t.string :outsidecontactaddress
      t.string :primarylanguage
      t.boolean :active

      t.timestamps
    end
  end
end
