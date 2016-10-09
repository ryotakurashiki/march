class User::TutorialsController < User::UserApplicationController

  def top
  end

  def select_janru
    redirect_to root_path if current_user.tutorial_finished
  end

  def select_artist
    redirect_to root_path if current_user.tutorial_finished
    @artists = Artist.where(category: params[:janru])
    @favorite_artist_ids = current_user.artists.pluck(:artist_id)
  end

  def select_concert
    @concerts = @artist.concerts.order("date DESC")
    @years = @concerts.pluck(:date).map{|date| ["#{date.year}年", date.year]}.uniq
    @concerts = @concerts.includes_for_list.page(params[:page])
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
  end

  def concert_artist_filter
  end

  def finish
    current_user.update(tutorial_finished: true)
    redirect_to root_path
  end
end

