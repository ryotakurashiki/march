class User::StaticsController < User::UserApplicationController
  def tutorial
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

