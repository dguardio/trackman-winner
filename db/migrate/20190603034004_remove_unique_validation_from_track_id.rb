class RemoveUniqueValidationFromTrackId < ActiveRecord::Migration[5.2]
  def change
  	remove_index :trackers, :trackid
  end
end
