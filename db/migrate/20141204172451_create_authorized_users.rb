class CreateAuthorizedUsers < ActiveRecord::Migration
  def change
    create_table :authorized_users do |t|
      t.text	:auth_server_user_id

      t.timestamps
    end
  end
end
