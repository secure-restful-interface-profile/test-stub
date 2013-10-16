class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :name
      t.string :obs_type
      t.string :value
      t.string :interpretation
      t.string :comments
      t.string :issued 
      t.string :period
      t.string :status
      t.string :reliability
      t.string :bodysite
      t.string :methodcode
      t.string :methodtext
      t.string :performer
      t.timestamps
    end
  end
end
