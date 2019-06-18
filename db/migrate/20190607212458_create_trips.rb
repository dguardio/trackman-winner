class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.float :start_lat
      t.float :start_lng
      t.float :end_lat
      t.float :end_lng
      t.text :remarks

      t.timestamps
    end
  end
end
