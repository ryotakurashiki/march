class UsersController < ApplicationController
  before_action :set_user
  def show
  	#render text: params[:username]
    @concerts = @this_user.concerts
    @artists = @this_user.artists
    @prefectures = @this_user.prefectures
  end

  def joining
    @concerts = @this_user.concerts.includes_for_list.
                open.order("date").page(params[:page])
  end

  def joined
    @concerts = @this_user.concerts.close
    @years = @concerts.pluck(:date).sort.reverse.map{|date| ["#{date.year}年", date.year]}.uniq.unshift(["全期間", nil])
    if params[:year].present?
      @year = params[:year].to_i
      @concerts = @concerts.this_year(@year)
    end
    @artist_ids_with_count = @concerts.joins(:appearance_artists).
    #@artist_ids_with_count = @concerts.includes(appearance_artists: :artist).
                             #references(appearance_artists: :artist).
                             group("appearance_artists.artist_id").order("count(*) DESC").count.to_a
    @concerts = @concerts.includes_for_list.
                order("date DESC").page(params[:page])
  end

  def favorite
    @artists = @this_user.artists.includes(:favorite_artists).references(:favorite_artists)
    @favorite_artist_ids = user_signed_in? ? current_user.artists.pluck(:artist_id) : []
  end

  private

  def set_user
  	@this_user = User.find_by(username: params[:username])
  end
end
