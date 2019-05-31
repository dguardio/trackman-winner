class ChangeTrackInfoOnLocation < ActiveRecord::Migration[5.2]
  def change
  	remove_column :locations, :trackinfo, :jsonb, null: false, default: '{}'  	
  	add_column :locations, :trackinfo, :jsonb, null: false, default: {}  	
  end
end
