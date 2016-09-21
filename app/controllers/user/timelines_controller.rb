class User::TimelinesController < User::UserApplicationController
  def future
    @title = "開催前のライブ"
    @concerts = Concert.all.limit(10)
    #render 'timeline'
  end

  def past
    @title = "終了したライブ"
    @concerts = Concert.all.limit(10)
    #render 'timeline'
  end
end

