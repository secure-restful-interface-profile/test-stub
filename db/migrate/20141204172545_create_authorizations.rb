class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.belongs_to	:patient
      t.belongs_to	:authorized_user

      t.timestamps
    end
  end
end
