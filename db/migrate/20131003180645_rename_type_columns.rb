class RenameTypeColumns < ActiveRecord::Migration
  def change

    rename_column :encounters, :type, :enc_type
    rename_column :observations, :type, :obs_type

  end
end
