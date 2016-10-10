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
    redirect_to root_path if current_user.tutorial_finished

    @artist = params[:artist_id] ? Artist.find(params[:artist_id]) : current_user.artists.first
    @concerts = @artist.concerts.close.order("date DESC")
    @years = @concerts.pluck(:date).map{|date| ["#{date.year}年", date.year]}.uniq
    @years ||= []
    @concerts = @concerts.close.includes_for_list.page(params[:page])
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
  end

  def finish
    current_user.update(tutorial_finished: true)
    #redirect_to root_path
    redirect_to user_joined_path(current_user.username)
  end
end

