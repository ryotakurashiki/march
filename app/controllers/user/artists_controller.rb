class User::ArtistsController < User::UserApplicationController

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

    def artist_params
      params.require(:artist).permit(:name)
    end
end
