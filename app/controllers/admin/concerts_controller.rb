class Admin::ConcertsController < Admin::AdminApplicationController
  before_action :set_concert, only: [:update, :destroy]

  def index
    @concerts = Concert.not_checked_concerts_by_user
  end

  def new
    @concert = Concert.new
  end

  def create
    @concert = Concert.new(concert_params)

    respond_to do |format|
      if @concert.save
        format.html { redirect_to @concert, notice: 'Concert was successfully created.' }
        format.json { render :show, status: :created, location: @concert }
      else
        format.html { render :new }
        format.json { render json: @concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deactive_concerts/1
  # PATCH/PUT /deactive_concerts/1.json
  def update
    if @concert.update(concert_params)
      render "update.js"
    end
  end

  def destroy
    @concert.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concert
      @concert = Concert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concert_params
      params.require(:concert).permit(
        :title, :place, :prefecture_id, :date, :category, :eplus_id, :livefans_path, :creator_id, :title_edited
      )
    end
end
