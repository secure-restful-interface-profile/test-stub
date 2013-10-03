class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|

      t.string :status
      t.string :class
      t.string :type
      t.string :participant
      t.string :participanttype
      t.string :start 
      t.string :length
      t.string :priority
      t.string :location
      t.string :locationperiod
      t.string :serviceprovider

      t.timestamps
    end
  end
end
