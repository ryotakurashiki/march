class ConcertsController < ApplicationController
  before_action :set_artist, only: [:show, :filter]
  before_action :set_concert, only: [:show]

  def show
    @years = @concerts.pluck(:date).map{|date| ["#{date.year}年", date.year]}.uniq
    @concerts = @concerts.includes_for_list.page(params[:page])
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
  end

  def filter
    if params[:year].present?
      year = params[:year].to_i
      if params[:prefecture_id].present?
        @concerts = @artist.concerts.where(prefecture_id: params[:prefecture_id]).this_year(year).order("date DESC")
      else
        @concerts = @artist.concerts.this_year(year).order("date DESC")
      end
    else
      if params[:prefecture_id].present?
        @concerts = @artist.concerts.where(prefecture_id: params[:prefecture_id]).order("date DESC")
      else
        @concerts = @artist.concerts.order("date DESC").page(params[:page])
      end
    end
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find(params[:artist_id])
    end

    def set_concert
      #@concert = Concert.find(params[:id])
      @concerts = @artist.concerts.order("date DESC")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concert_params
      params.require(:concert).permit(:title, :place, :prefecture_id, :date, :eplus_id)
    end
end
