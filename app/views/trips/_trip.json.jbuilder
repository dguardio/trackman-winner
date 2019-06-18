json.extract! trip, :id, :start_lat, :start_lng, :end_lat, :end_lng, :remarks, :created_at, :updated_at
json.url trip_url(trip, format: :json)
