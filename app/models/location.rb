class Location < ApplicationRecord
	belongs_to :tracker, optional: true 
	# include Scopy::CreatedAtScopes
	
end
