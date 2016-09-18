class User::StaticsController < User::UserApplicationController
  def tutorial
  end

  def tutorial_janru
    #render text: params[:janru]
    @artists = Artist.where(category: params[:janru])
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

