class ChangeColumnsOnTracker < ActiveRecord::Migration[5.2]
  def change
  	remove_column :trackers, :trackinfo
  	add_column :trackers, :latitude, :float
  	add_column :trackers, :longitude, :float
  	add_column :trackers, :height_above_sea, :integer
  	add_column :trackers, :speed, :integer
	
  	add_index :trackers, :latitude
  	add_index :trackers, :longitude
  	add_index :trackers, :height_above_sea
  	add_index :trackers, :speed  	

  end
end
