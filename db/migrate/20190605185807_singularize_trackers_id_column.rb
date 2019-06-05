class SingularizeTrackersIdColumn < ActiveRecord::Migration[5.2]
  def change
  	rename_column :locations, :trackers_id, :tracker_id
  end
end
