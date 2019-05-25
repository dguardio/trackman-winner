class CreateTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :trackers do |t|
      t.string :trackid
      t.json :trackinfo

      t.timestamps
    end
  end
end
