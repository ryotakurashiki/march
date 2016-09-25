class User::TutorialsController < User::UserApplicationController
  def select_janru
    redirect_to root_path if current_user.tutorial_finished
  end

  def select_artist
    redirect_to root_path if current_user.tutorial_finished
    @artists = Artist.where(category: params[:janru])
    @favorite_artist_ids = current_user.artists.pluck(:artist_id)
  end

  def finish
    current_user.update(tutorial_finished: true)
    redirect_to root_path
  end
end

