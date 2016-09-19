class User::TimelinesController < User::UserApplicationController
  def future
    @title = "開催前のライブ"
    @concerts = Concert.all.limit(10)
    render 'timeline'
  end

  def past
    @title = "開催後のライブ"
    @concerts = Concert.all.limit(10)
    render 'timeline'
  end
end

