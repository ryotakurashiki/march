class MediumArtistRelationsController < ApplicationController
  before_action :set_medium_artist_relation, only: [:show, :edit, :update, :destroy]

  # GET /medium_artist_relations
  # GET /medium_artist_relations.json
  def index
    @medium_artist_relations = MediumArtistRelation.all
  end

  # GET /medium_artist_relations/1
  # GET /medium_artist_relations/1.json
  def show
  end

  # GET /medium_artist_relations/new
  def new
    @medium_artist_relation = MediumArtistRelation.new
  end

  # GET /medium_artist_relations/1/edit
  def edit
  end

  # POST /medium_artist_relations
  # POST /medium_artist_relations.json
  def create
    @medium_artist_relation = MediumArtistRelation.new(medium_artist_relation_params)

    respond_to do |format|
      if @medium_artist_relation.save
        format.html { redirect_to @medium_artist_relation, notice: 'Medium artist relation was successfully created.' }
        format.json { render :show, status: :created, location: @medium_artist_relation }
      else
        format.html { render :new }
        format.json { render json: @medium_artist_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medium_artist_relations/1
  # PATCH/PUT /medium_artist_relations/1.json
  def update
    respond_to do |format|
      if @medium_artist_relation.update(medium_artist_relation_params)
        format.html { redirect_to @medium_artist_relation, notice: 'Medium artist relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @medium_artist_relation }
      else
        format.html { render :edit }
        format.json { render json: @medium_artist_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medium_artist_relations/1
  # DELETE /medium_artist_relations/1.json
  def destroy
    @medium_artist_relation.destroy
    respond_to do |format|
      format.html { redirect_to medium_artist_relations_url, notice: 'Medium artist relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium_artist_relation
      @medium_artist_relation = MediumArtistRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medium_artist_relation_params
      params.require(:medium_artist_relation).permit(:medium_id, :artist_id, :medium_artist_id)
    end
end
