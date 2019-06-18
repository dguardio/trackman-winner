class TrackersController < ApplicationController
  # before_action :set_tracker, only: [:show, :edit, :update, :destroy]
  # GET /trackers
  # GET /trackers.json
  skip_before_action :verify_authenticity_token, :only => [:create, :update]


  def index
    # @response = HTTParty.get('http://devloc.herokuapp.com/api/devices')
    # @trackers = JSON.parse(@response.body)
    # @trackerObject = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    # @trackers.each do |tracker|
    #   tracker["info"].each do |info|
    #     @trackerObject[info["device_id"]]["latitude"] = info["latitude"]
    #     @trackerObject[info["device_id"]]["longitude"] = info["longitude"]
    #   end
    # end
    # @hash = Gmaps4rails.build_markers(@trackerObject) do |tracker, marker|
    #   marker.lat tracker[1]["latitude"]
    #   marker.lng tracker[1]["longitude"]
    #   # marker.picture({
    #   #   url: "/images/walk.png",
    #   #   width:  50,
    #   #   height: 50
    #   # })      
    # end
    # return @hash
# For DB Querying once move is made to leave API
    @trackers = Tracker.all
    @hash = Gmaps4rails.build_markers(@trackers) do |tracker, marker|
      marker.lat tracker.latitude
      marker.lng tracker.longitude
      # marker.picture({
      #   url: "/images/walk.png",
      #   width:  50,
      #   height: 50
      # })      
    end
    return @hash        
  end

  def trackers_index
    @trackers = Tracker.all
  end

  # GET /trackers/1
  # GET /trackers/1.json
  def show
    # @current_tracker = params[:id]
    # @response = HTTParty.get('http://devloc.herokuapp.com/api/devices/'+ @current_tracker)
    # @tracker = JSON.parse(@response.body)
    # @trackerObject = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }

    # @tracker["info"].each do |info|
    #     @trackerObject[info["device_id"]]["latitude"] = info["latitude"]
    #     @trackerObject[info["device_id"]]["longitude"] = info["longitude"]
    # end

    # @hash = Gmaps4rails.build_markers(@trackerObject) do |tracker, marker|
    #   marker.lat tracker[1]["latitude"]
    #   marker.lng tracker[1]["longitude"]
    #   # marker.picture({
    #   #   url: "/images/walk.png",
    #   #   width:  50,
    #   #   height: 50
    #   # })
    # end
    # return @hash 
# For DB Querying once move is made to leave API
    @tracker = Tracker.find(params[:id])   
    @hash = Gmaps4rails.build_markers(@tracker) do |tracker, marker|
      marker.lat tracker.latitude
      marker.lng tracker.longitude
      # marker.picture({
      #   url: "/images/walk.png",
      #   width:  50,
      #   height: 50
      # })
    end
    return @hash     
  end



  def fetch_devices  
    # @response = HTTParty.get('http://devloc.herokuapp.com/api/devices')
    # @trackers = JSON.parse(@response.body)
    # @trackerObject = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    # @trackers.each do |tracker|
    #   tracker["info"].each do |info|
    #     @trackerObject[info["device_id"]]["latitude"] = info["latitude"]
    #     @trackerObject[info["device_id"]]["longitude"] = info["longitude"]
    #   end
    # end
    # @hash = Gmaps4rails.build_markers(@trackerObject) do |tracker, marker|
    #   marker.lat tracker[1]["latitude"]
    #   marker.lng tracker[1]["longitude"]
    #   # marker.picture({
    #   #   url: "/images/walk.png",
    #   #   width:  50,
    #   #   height: 50
    #   # })      
    # end
    # render json: @hash, status: :ok  

    @trackers = Tracker.all 
    @hash = Gmaps4rails.build_markers(@trackers) do |tracker, marker|
      marker.lat tracker.latitude
      marker.lng tracker.longitude
      # marker.picture({
      #   url: "/images/walk.png",
      #   width:  50,
      #   height: 50
      # })      
    end
    render json: @hash, status: :ok     
  end

  def fetch_single_device
    # @response = HTTParty.get('http://devloc.herokuapp.com/api/devices/'+ params[:id])
    # @tracker = JSON.parse(@response.body)
    # @trackerObject = Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }

    # @tracker["info"].each do |info|
    #     @trackerObject[info["device_id"]]["latitude"] = info["latitude"]
    #     @trackerObject[info["device_id"]]["longitude"] = info["longitude"]
    # end

    # @hash = Gmaps4rails.build_markers(@trackerObject) do |tracker, marker|
    #   marker.lat tracker[1]["latitude"]
    #   marker.lng tracker[1]["longitude"]
    #   # marker.picture({
    #   #   url: "/images/walk.png",
    #   #   width:  50,
    #   #   height: 50
    #   # })
    # end
    # render json: @hash, status: :ok 

    @tracker = Tracker.find(params[:id])
    @hash = Gmaps4rails.build_markers(@tracker) do |tracker, marker|
      marker.lat tracker.latitude
      marker.lng tracker.longitude
      # marker.picture({
      #   url: "/images/walk.png",
      #   width:  50,
      #   height: 50
      # })
    end
    render json: @hash, status: :ok 
  end



  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # GET /trackers/1/edit
  def edit
    @tracker = Tracker.find(params[:id])
  end

  # POST /trackers
  # POST /trackers.json
  def create
    @tracker = Tracker.new(tracker_params)
      if @tracker.save
        # format.html {redirect_to @tracker, notice: 'Tracker was successfully created.' and return}
        render json: @tracker, status: :created
        # This stores the trackers location into the Historical location table 
        # where all locations tracked by the tracker will be stored
        @store = Location.new
        @store.trackid = @tracker.trackid
        @store.tracker_id = @tracker.id
        @store.trackinfo = {
          @tracker.created_at => {
            "trackid" => @tracker.trackid,
            "latitude" => @tracker.latitude, 
            "longitude" => @tracker.longitude, 
            "height_above_sea" => @tracker.height_above_sea, 
            "speed" => @tracker.speed
          }
        }.to_json 
        @store.save!
      else
        # format.html { render :new }
        render json: @tracker.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    @tracker = Tracker.find(params[:tracker_id])
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @tempLat = @latitude/100
    @floatLat = (@latitude - (@tempLat * 100))/60
    @lat = @tempLat + @floatLat
    @tempLng = @longitude/100
    @floatLng = (@longitude - (@tempLng * 100))/60
    @lng = @tempLng + @floatLng
    params[:latitude] ||= @lat.to_s 
    params[:longitude] ||= @lng.to_s    
      if @tracker.update(tracker_params)
        # format.html {redirect_to @tracker, notice: 'Tracker was successfully updated.' and return}
        render json: @tracker, status: :ok
        @store = Location.find_by(tracker_id: @tracker.id)
        original_json = @store.trackinfo
        new_json = {
          @tracker.updated_at => {
            "trackid" => @tracker.trackid,
            "latitude" => @tracker.latitude, 
            "longitude" => @tracker.longitude, 
            "height_above_sea" => @tracker.height_above_sea, 
            "speed" => @tracker.speed
          }
        }
        @store.trackinfo = original_json.merge!(new_json)
        @store.save!        
      else
        # format.html { render :edit }
        render json: @tracker.errors, status: :unprocessable_entity
      end
  end

  # DELETE /trackers/1
  # DELETE /trackers/1.json
  def destroy
    @tracker = Tracker.find(params[:id]) 
    @tracker.destroy
    respond_to do |format|
      format.html { redirect_to trackers_url, notice: 'Tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_tracker
    #   @tracker = Tracker.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
      # tracker_keys = params[:tracker].try(:fetch, :trackinfo, {}).keys
      # params.require(:tracker).permit(:trackid, trackinfo: tracker_keys)
      # params.require(:tracker).permit(:trackid, {:trackinfo => [:device_id, :latitude, :longitude]})
      params.require(:tracker).permit(
        :trackid,
        :latitude, 
        :longitude, 
        :height_above_sea, 
        :speed
        )
    end
end
