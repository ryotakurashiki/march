class Admin::DeactiveConcertsController < Admin::AdminApplicationController
  before_action :set_deactive_concert, only: [:show, :edit, :update, :destroy]

  # GET /deactive_concerts
  # GET /deactive_concerts.json
  def index
    @deactive_concerts = DeactiveConcert.all
  end

  # GET /deactive_concerts/1
  # GET /deactive_concerts/1.json
  def show
  end

  # GET /deactive_concerts/new
  def new
    @deactive_concert = DeactiveConcert.new
  end

  # GET /deactive_concerts/1/edit
  def edit
  end

  # POST /deactive_concerts
  # POST /deactive_concerts.json
  def create
    @deactive_concert = DeactiveConcert.new(deactive_concert_params)

    respond_to do |format|
      if @deactive_concert.save
        format.html { redirect_to @deactive_concert, notice: 'Deactive concert was successfully created.' }
        format.json { render :show, status: :created, location: @deactive_concert }
      else
        format.html { render :new }
        format.json { render json: @deactive_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deactive_concerts/1
  # PATCH/PUT /deactive_concerts/1.json
  def update
    respond_to do |format|
      if @deactive_concert.update(deactive_concert_params)
        format.html { redirect_to @deactive_concert, notice: 'Deactive concert was successfully updated.' }
        format.json { render :show, status: :ok, location: @deactive_concert }
      else
        format.html { render :edit }
        format.json { render json: @deactive_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deactive_concerts/1
  # DELETE /deactive_concerts/1.json
  def destroy
    @deactive_concert.destroy
    respond_to do |format|
      format.html { redirect_to deactive_concerts_url, notice: 'Deactive concert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deactive_concert
      @deactive_concert = DeactiveConcert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deactive_concert_params
      params.require(:deactive_concert).permit(:title, :place, :prefecture_id, :date, :category, :integer, :eplus_id, :date_text, :active)
    end
end
