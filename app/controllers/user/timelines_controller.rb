class User::TimelinesController < User::UserApplicationController
  before_action :set_concerts, only: [:future, :past]

  def future
    @title = "開催前のライブ"
    prefectures = current_user.prefectures
    if prefectures.present?
      @concerts = @concerts.joins(:prefecture).merge(current_user.prefectures).
        open.limit(200).order("date")
    else
      @concerts = @concerts.open.limit(200).order("date")
    end
    #@concerts = Concert.all.limit(10)
    #render 'timeline'
  end

  def past
    @title = "終了したライブ"
    @concerts = @concerts.close.limit(200).order("date DESC")
    #@concerts = Concert.all.limit(10)
    #render 'timeline'
  end

  private

  def set_concerts
    favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
    @concerts = Concert.includes(:appearance_artists).where(appearance_artists: {artist_id: favorite_artist_ids})
  end
end

