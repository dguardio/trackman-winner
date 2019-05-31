class AddIndexToLocation < ActiveRecord::Migration[5.2]
  def change
  	remove_column :locations, :trackinfo
  	add_column :locations, :trackinfo, :jsonb, null: false, default: '{}'

  	add_index :locations, :trackinfo, :using => :gin  	
  end
end
