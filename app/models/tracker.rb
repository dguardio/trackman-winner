class Tracker < ApplicationRecord
	has_one :location
  has_many :trips
  before_create :transform_data
  before_save :transform_data
  # validates :trackid, :uniqueness => true

def transform_data
  latitude = self.latitude
  longitude = self.longitude
  tempLat = latitude/100
  floatLat = (latitude - (tempLat * 100))/60
  lat = tempLat + floatLat
  tempLng = longitude/100
  floatLng = (longitude - (tempLng * 100))/60
  lng = tempLng + floatLng
  self.latitude = lat 
  self.longitude = lng  
end

  # def self.save_data_from_api
  #   response = HTTParty.get('http://devloc.herokuapp.com/api/devices')
  #   tracker_data = JSON.parse(response)
  #   trackers = tracker_data.map do |line|
  #     t = Tracker.new
  #     t.trackid = line['info']['device_id']
  #     t.trackinfo = line['info']
  #     # set name value however you want to do that
  #     t.save
  #     t
  #   end
  #   t.select(&:persisted?)
  # end

end
