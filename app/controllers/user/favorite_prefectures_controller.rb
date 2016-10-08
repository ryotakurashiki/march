class User::FavoritePrefecturesController < User::UserApplicationController
  before_action :set_favorite_prefecture, only: [:destroy]

  def create
    @favorite_prefecture = current_user.favorite_prefectures.new(favorite_prefecture_params)
    @favorite_prefecture.save
  end

  def destroy
    @favorite_prefecture.destroy
  end

  def show
    @user = current_user
    @favorite_prefectures = @user.favorite_prefectures
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite_prefecture
      @favorite_prefecture = FavoritePrefecture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_prefecture_params
      params.require(:favorite_prefecture).permit(:user_id, :prefecture_id)
    end

end
