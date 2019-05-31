class Location < ApplicationRecord
	belongs_to :tracker, optional: true 
end
