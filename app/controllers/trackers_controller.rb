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
        new_json = {
          @tracker.updated_at => {
            "trackid" => @tracker.trackid,
            "latitude" => @tracker.latitude, 
            "longitude" => @tracker.longitude, 
            "height_above_sea" => @tracker.height_above_sea, 
            "speed" => @tracker.speed
          }
        }
        @store.trackinfo.reverse_merge!(new_json)
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
