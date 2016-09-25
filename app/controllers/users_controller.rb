class UsersController < ApplicationController
  before_action :set_user
  before_action :set_concerts
  def show
  	#render text: params[:username]
    @concerts = @this_user.concerts
    @artists = @this_user.artists
    @prefectures = @this_user.prefectures
  end

  def joining
    @concerts = @concerts.includes(:user_concert_joinings, :appearance_artists).
      open.order("date").page(params[:page])
  end

  def joined
    @concerts = @concerts.includes(:user_concert_joinings).close
    @years = @concerts.pluck(:date).sort.reverse.map{|date| ["#{date.year}年", date.year]}.uniq.unshift(["全期間", nil])
    if params[:year].present?
      @year = params[:year].to_i
      @concerts = @concerts.this_year(@year)
    end
    @artist_ids_with_count = @concerts.joins(:appearance_artists).group("appearance_artists.artist_id").order("count(*) DESC").count.to_a
    #render text: @artist_ids_with_count
    @concerts = @concerts.order("date DESC").page(params[:page])
  end

  def favorite
    @artists = @this_user.artists.includes(:favorite_artists).references(:favorite_artists)
    @favorite_artist_ids = user_signed_in? ? current_user.artists.pluck(:artist_id) : []
  end

  private

  def set_user
  	@this_user = User.find_by(username: params[:username])
  end

  def set_concerts
    @concerts = @this_user.concerts
  end
end
