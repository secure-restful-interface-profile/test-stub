class RenameEncounterFields < ActiveRecord::Migration
  def change
    change_table :encounters do |t|
      t.rename :class, :enc_class
    end
  end
end
