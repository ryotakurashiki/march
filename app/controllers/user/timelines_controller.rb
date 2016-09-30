class User::TimelinesController < User::UserApplicationController
  before_action :set_favorite_artist_ids, only: [:future, :past]

  def future
    prefectures = current_user.prefectures
    if prefectures.present?
      @favorite_prefecture_ids = current_user.prefectures.pluck(:id)
      concert_ids = Concert.includes(:prefecture, :appearance_artists).
                    where(prefecture_id: @favorite_prefecture_ids, appearance_artists: {artist_id: @favorite_artist_ids}).
                    open.order("date").take(200).pluck(:id)

      @concerts = Concert.includes_for_list.where(id: concert_ids).page(params[:page])

    else
      concert_ids = Concert.includes(:prefecture, :appearance_artists).
                    where(appearance_artists: {artist_id: @favorite_artist_ids}).
                    open.order("date").take(200).pluck(:id)

      @concerts = Concert.includes_for_list.where(id: concert_ids).page(params[:page])
    end
  end

  def past
    concert_ids = Concert.includes(:prefecture, :appearance_artists).
                  where(appearance_artists: {artist_id: @favorite_artist_ids}).
                  close.order("date DESC").take(200).pluck(:id)
    @concerts = Concert.includes(:prefecture, user_concert_joinings: :user,
                appearance_artists: {artist: :favorite_artists}).
                where(id: concert_ids).page(params[:page])
  end

  private

  def set_favorite_artist_ids
    @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    #@concerts = Concert.includes(:appearance_artists).where(appearance_artists: {artist_id: favorite_artist_ids})
  end
end

