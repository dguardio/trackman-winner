class AddIndexToTracker < ActiveRecord::Migration[5.2]
  def change
  	remove_column :trackers, :trackinfo
  	add_column :trackers, :trackinfo, :jsonb, null: false, default: '{}'

  	add_index :trackers, :trackid, :unique => :true
  	add_index :trackers, :trackinfo, :using => :gin
  end
end
