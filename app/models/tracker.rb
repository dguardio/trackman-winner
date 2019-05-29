class Tracker < ApplicationRecord

  # validates :trackid, :uniqueness => true

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
