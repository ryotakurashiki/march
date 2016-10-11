class User::ConcertsController < User::UserApplicationController
  before_action :redirect_favorite_prefecture, only: [:index]
  before_action :set_concert, only: [:update, :edit]
  before_action :set_concert_ids, only: [:index, :filter]
  before_action :set_years, only: [:index, :filter]

  def new
    @concert = Concert.new
    @concert.appearance_artists.build
  end

  def edit
  end

  def index
    @concerts = Concert.includes_for_list.where(id: @concert_ids).order("date DESC").page(params[:page])
    @join_concert_ids = Concert.ids_joined_by(current_user, @concerts)
  end

  def filter
    @concerts = Concert.includes_for_list.where(id: @concert_ids).order("date DESC").page(params[:page])
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
    render template: "concerts/filter.js"
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
      redirect_to new_concert_path
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

  def check_duplicate
    date = Date.parse(params[:date_text])
    prefecture_id = params[:prefecture_id].to_i

    concert_ids = Concert.includes(:appearance_artists).
                  where(date: date, appearance_artists: {artist_id: params[:aids]}).pluck(:id)
    @concerts = Concert.includes_for_list.where(id: concert_ids).limit(1)
    @join_concert_ids = user_signed_in? ? Concert.ids_joined_by(current_user, @concerts) : []
    #render "check_duplicate.js"
  end

  def add_appearance_artist
    concert_id = params[:concert_id].to_i
    artist_id = params[:artist_id].to_i
    @appearance_artist = Concert.find(concert_id).appearance_artists.build(artist_id: artist_id)
    if @appearance_artist.save
      @appearance_artist.update(creator_id: current_user.id)
    else
    end
  end

  private

    def set_concert
      @concert = Concert.includes_for_list.find(params[:id])
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

    def redirect_favorite_prefecture
      unless request.url.match(/prefecture_id/)
        if current_user.prefectures.present?
          favorite_prefecture_id = current_user.favorite_prefectures.first.prefecture_id
          redirect_to concerts_path(prefecture_id: favorite_prefecture_id)
        end
      end
    end

    def set_concert_ids
      update_favorite_prefecture(params[:prefecture_id])
      @favorite_artist_ids = current_user.favorite_artists.pluck(:artist_id)
      #@concert_ids = Concert.includes(:prefecture, :appearance_artists).
                    #where(appearance_artists: {artist_id: @favorite_artist_ids}).
                    #order("date").take(200).pluck(:id)

      if params[:year].present?
        @year = params[:year].to_i
        if params[:prefecture_id].present?
          @prefecture_id = params[:prefecture_id]
          @concert_ids = Concert.includes(:prefecture, :appearance_artists).
                         where(appearance_artists: {artist_id: @favorite_artist_ids}, prefecture_id: @prefecture_id).
                         this_year(@year).order("date DESC").take(300).pluck(:id)
        else
          @concert_ids = Concert.includes(:prefecture, :appearance_artists).
                         where(appearance_artists: {artist_id: @favorite_artist_ids}).
                         this_year(@year).order("date DESC").take(300).pluck(:id)
        end
      else
        if params[:prefecture_id].present?
          @prefecture_id = params[:prefecture_id]
          @concert_ids = Concert.includes(:prefecture, :appearance_artists).
                         where(appearance_artists: {artist_id: @favorite_artist_ids}, prefecture_id: @prefecture_id).
                         order("date DESC").take(300).pluck(:id)
        else
          @concert_ids = Concert.includes(:prefecture, :appearance_artists).
                         where(appearance_artists: {artist_id: @favorite_artist_ids}).
                         order("date DESC").take(300).pluck(:id)
        end
      end
    end

    def set_years
      years = [*1996..Date.today.year].reverse
      @years = years.map{|year| ["#{year}年", year]}
    end
end
