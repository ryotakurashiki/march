class User::StaticsController < User::UserApplicationController
  def tutorial
    redirect_to root_path if current_user.tutorial_finished
  end

  def tutorial_janru
    redirect_to root_path if current_user.tutorial_finished
    @artists = Artist.where(category: params[:janru])
  end

  def tutorial_finish
    current_user.update(tutorial_finished: true)
    redirect_to root_path
  end

  def timeline_future
    @concerts = Concert.all.limit(10)
    render 'timeline'
  end

  def timeline_past
    @concerts = Concert.all.limit(10)
    render 'timeline'
  end
end

