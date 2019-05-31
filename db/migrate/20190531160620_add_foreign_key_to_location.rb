class AddForeignKeyToLocation < ActiveRecord::Migration[5.2]
  def change
  	add_reference :locations, :trackers, foreign_key: true
  end
end
