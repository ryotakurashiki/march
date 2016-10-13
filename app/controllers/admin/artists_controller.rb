class Admin::ArtistsController < Admin::AdminApplicationController
  before_action :set_artist, only: [:update, :destroy]

  def index
    @artists = Artist.includes(:medium_artist_relations).where(admin_denied: true)
  end

  def update
    if @artist.update(artist_params)
      @artist.medium_artist_relations.create(medium_artist_relation_params)
      render "update.js"
    end
  end

  def destroy
    @artist.destroy
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      @artist.update(creator_id: current_user.id, admin_denied: true)
      render "create.js"
    else
      render "error.js"
    end
  end

  private
    def set_artist
      @artist = Artist.find(params[:id])
    end

    def artist_params
      params.require(:artist).permit(:name, :admin_denied, medium_artist_relations: [:medium_id, :medium_artist_id])
    end

    def medium_artist_relation_params
      params.require(:medium_artist_relation).permit(:medium_id, :medium_artist_id)
    end
end
