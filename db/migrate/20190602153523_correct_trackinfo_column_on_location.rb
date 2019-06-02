class CorrectTrackinfoColumnOnLocation < ActiveRecord::Migration[5.2]
  def change
  	change_column :locations, :trackinfo, :jsonb, null: false, default: "{}"    	  	
  end
end
