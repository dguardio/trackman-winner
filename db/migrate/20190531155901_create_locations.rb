class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :trackid
      t.jsonb :trackinfo

      t.timestamps
    end
  end
end
