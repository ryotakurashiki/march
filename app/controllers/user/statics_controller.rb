class User::StaticsController < User::UserApplicationController
  def tutorial
  end

  def timeline
    @concerts = Concert.all.limit(10)
  end
end

