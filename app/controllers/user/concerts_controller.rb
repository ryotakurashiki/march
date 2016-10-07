class User::ConcertsController < User::UserApplicationController
  before_action :set_concert, only: [:update]

  def new
    @concert = Concert.new
    @concert.appearance_artists.build
  end

  def create
    @concert = Concert.new(concert_params)
    #render text: params[:auto_register] == "1"
    artist_ids = params[:appearance_artist][:artist_id].values
    if @concert.save!
      @concert.update(creator_id: current_user.id)
      artist_ids.each do |aid|
        @concert.appearance_artists.create(artist_id: aid)
      end
      @concert.appearance_artists.update_all(creator_id: current_user.id)
      flash[:info] = "ライブを作成しました"
      redirect_to new_concerts_path
    else
      render :new
    end
    if params[:auto_register] == "1"
      @concert.user_concert_joinings.create(user_id: current_user.id)
    end
  end

  def update
    if @concert.update(concert_params)
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

    def set_concert
      @concert = Concert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concert_params
      params.require(:concert).permit(
        :title, :place, :prefecture_id, :date, :eplus_id, :livefans_path, :creator_id
      )
    end

    def artist_params
      params.require(:appearance_artist).permit(:artist_id)
    end
end
