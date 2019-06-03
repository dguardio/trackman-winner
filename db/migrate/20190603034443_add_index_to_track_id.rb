class AddIndexToTrackId < ActiveRecord::Migration[5.2]
  def change
  	add_index :trackers, :trackid
  end
end
