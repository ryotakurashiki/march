class ConcertsController < ApplicationController
  before_action :set_artist, only: [:show, :filter]
  before_action :set_concert, only: [:show]

  def show
  end

  def filter
    @concerts = @artist.concerts.where(prefecture_id: params[:prefecture_id]).order("date DESC")
    #render json: @concerts, status: :ok
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
