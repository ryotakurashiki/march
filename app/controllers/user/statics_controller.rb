class User::StaticsController < User::ApplicationController
  def tutorial
  end

  def timeline
    @concerts = Concert.all.limit(10)
  end
end

