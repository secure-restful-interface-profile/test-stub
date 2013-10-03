class RemoveEncounters < ActiveRecord::Migration
  def change
    drop_table :encounters
  end
end
