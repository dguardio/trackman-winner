class TrackersController < ApplicationController
  # before_action :set_tracker, only: [:show, :edit, :update, :destroy]
  # GET /trackers
  # GET /trackers.json
  skip_before_action :verify_authenticity_token, :only => [:create, :update]


  def index
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

  def metrics
    @tracker = Tracker.find(params[:tracker_id])
# All TrackInfo Gathered and stored for this Tracker 
    @all_time_data = @tracker.location.trackinfo
# The Keys used to access the last 20 records of this tracker stored in the Record
    @last_twenty_data_keys = @all_time_data.keys.last(20)
    # The keys to access all the records of this tracker stored in the Record 
    @all_time_data_keys = @all_time_data.keys
# The Empty GArrays to store the Speed Values for both the Last twenty saved records and the all time saved records using a loop
    @last_twenty_speed_values = Array.new
    @all_time_speed_values = Array.new

    # Use these Arrays to Transform each Timestamp key to a date readable form

    @transformed_twenty_speed_keys = Array.new
    @transformed_all_speed_keys = Array.new

    x = 0
    while x < @last_twenty_data_keys.length
      @last_twenty_speed_values << @all_time_data[@last_twenty_data_keys[x]]["speed"]
      @transformed_twenty_speed_keys << Date.parse(@last_twenty_data_keys[x]).strftime("%I:%M:%S %p, %a")
      x += 1
    end
    # For setting All Speeds into array to be displayed by Chartist in View
    t = 0
    while t < @all_time_data_keys.length
      @all_time_speed_values << @all_time_data[@all_time_data_keys[t]]["speed"]
      @transformed_all_speed_keys << Date.parse(@all_time_data_keys[t]).strftime("%I:%M:%S %p, %a")
      t += 1
    end
    puts @transformed_twenty_speed_keys
    puts @transformed_all_speed_keys    
  end

  def fetch_devices   
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
      if @tracker.update(tracker_params)
        # format.html {redirect_to @tracker, notice: 'Tracker was successfully updated.' and return}
        render json: @tracker, status: :ok
        @store = Location.find_by(tracker_id: @tracker.id)
        if @store.trackinfo.instance_of? String
          original_json = JSON.parse(@store.trackinfo)
        else
          original_json = @store.trackinfo
        end
        new_json = {
          @tracker.updated_at => {
            "trackid" => @tracker.trackid,
            "latitude" => @tracker.latitude, 
            "longitude" => @tracker.longitude, 
            "height_above_sea" => @tracker.height_above_sea, 
            "speed" => @tracker.speed
          }
        }
        @store.trackinfo = original_json.reverse_merge!(new_json)
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
