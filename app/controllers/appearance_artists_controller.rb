class AppearanceArtistsController < ApplicationController
  before_action :set_appearance_artist, only: [:show, :edit, :update, :destroy]

  # GET /appearance_artists
  # GET /appearance_artists.json
  def index
    @appearance_artists = AppearanceArtist.all
  end

  # GET /appearance_artists/1
  # GET /appearance_artists/1.json
  def show
  end

  # GET /appearance_artists/new
  def new
    @appearance_artist = AppearanceArtist.new
  end

  # GET /appearance_artists/1/edit
  def edit
  end

  # POST /appearance_artists
  # POST /appearance_artists.json
  def create
    @appearance_artist = AppearanceArtist.new(appearance_artist_params)

    respond_to do |format|
      if @appearance_artist.save
        format.html { redirect_to @appearance_artist, notice: 'Appearance artist was successfully created.' }
        format.json { render :show, status: :created, location: @appearance_artist }
      else
        format.html { render :new }
        format.json { render json: @appearance_artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appearance_artists/1
  # PATCH/PUT /appearance_artists/1.json
  def update
    respond_to do |format|
      if @appearance_artist.update(appearance_artist_params)
        format.html { redirect_to @appearance_artist, notice: 'Appearance artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @appearance_artist }
      else
        format.html { render :edit }
        format.json { render json: @appearance_artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appearance_artists/1
  # DELETE /appearance_artists/1.json
  def destroy
    @appearance_artist.destroy
    respond_to do |format|
      format.html { redirect_to appearance_artists_url, notice: 'Appearance artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appearance_artist
      @appearance_artist = AppearanceArtist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appearance_artist_params
      params.require(:appearance_artist).permit(:concert_id, :artist_id)
    end
end
