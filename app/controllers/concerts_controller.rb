class ConcertsController < ApplicationController
  before_action :set_artist, only: [:show, :filter]
  before_action :set_concert, only: [:show]

  def show
    @years = @concerts.pluck(:date).map{|date| ["#{date.year}年", date.year]}.uniq
    @concerts = @concerts.page(params[:page])
  end

  def filter
    if params[:prefecture_id]
      @concerts = @artist.concerts.where(prefecture_id: params[:prefecture_id]).order("date DESC").page(params[:page])
    elsif params[:year]
      year = params[:year].to_i
      #first_date = Date.new(2000, 1, 1)
      #last_date = Date.new(2000, 12, 31)
      @concerts = @artist.concerts.this_year(year).order("date DESC").page(params[:page])
      #where(arel_table[:date].lteq(last_date).gteq(first_date)).order("date DESC")
    end
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
