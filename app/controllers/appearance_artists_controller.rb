class AppearanceArtistsController < ApplicationController
  before_action :set_concert, only: [:sort]

  def sort
    @appearance_artists = AppearanceArtist.sorted_by_user_with_concert(current_user, @concert)
    #@appearance_artists = AppearanceArtist.includes(:artist).where(id: appearance_artists.map{ |a| a.id })
    #@appearance_artists = @concert.appearance_artists.
    #                      includes(artist: :favorite_artists).
    #                      joins("AND favorite_artists.user_id = #{current_user.id}").
    #                      order("favorite_artists.id DESC")
  end

  private
    def set_concert
      @concert = Concert.find(params[:concert_id])
    end
end