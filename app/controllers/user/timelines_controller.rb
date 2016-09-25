class User::TimelinesController < User::UserApplicationController
  before_action :set_favorite_artist_ids, only: [:future, :past]

  def future
    @title = "開催前のライブ"
    prefectures = current_user.prefectures
    if prefectures.present?
      @favorite_prefecture_ids = current_user.prefectures.pluck(:id)
      @concerts = Concert.eager_load(:appearance_artists, :user_concert_joinings).
        joins("AND user_concert_joinings.user_id = #{current_user.id}").
        where(prefecture_id: @favorite_prefecture_ids, appearance_artists: {artist_id: @favorite_artist_ids}).
        open.order("date").limit(200).page(params[:page])
    else
      @concerts = Concert.eager_load(:appearance_artists, :user_concert_joinings).
        joins("AND user_concert_joinings.user_id = #{current_user.id}").
        where(appearance_artists: {artist_id: @favorite_artist_ids}).
        open.order("date").limit(200).page(params[:page])
    end
    #@concerts = Concert.all.limit(10)
    #render 'timeline'
  end

  def past
    @title = "終了したライブ"
    @concerts = Concert.includes(:appearance_artists).
      where(appearance_artists: {artist_id: @favorite_artist_ids}).
      close.limit(200).order("date DESC").page(params[:page])

    #render 'timeline'
  end

  private

  def set_favorite_artist_ids
    @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    #@concerts = Concert.includes(:appearance_artists).where(appearance_artists: {artist_id: favorite_artist_ids})
  end
end

