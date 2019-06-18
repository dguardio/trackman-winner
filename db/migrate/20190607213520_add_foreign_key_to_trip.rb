class AddForeignKeyToTrip < ActiveRecord::Migration[5.2]
  def change
  	add_reference :trips, :tracker, foreign_key: true
  end
end
