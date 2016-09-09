class ArtistRelationsController < ApplicationController
  before_action :set_artist_relation, only: [:show, :edit, :update, :destroy]

  # GET /artist_relations
  # GET /artist_relations.json
  def index
    @artist_relations = ArtistRelation.all
  end

  # GET /artist_relations/1
  # GET /artist_relations/1.json
  def show
  end

  # GET /artist_relations/new
  def new
    @artist_relation = ArtistRelation.new
  end

  # GET /artist_relations/1/edit
  def edit
  end

  # POST /artist_relations
  # POST /artist_relations.json
  def create
    @artist_relation = ArtistRelation.new(artist_relation_params)

    respond_to do |format|
      if @artist_relation.save
        format.html { redirect_to @artist_relation, notice: 'Artist relation was successfully created.' }
        format.json { render :show, status: :created, location: @artist_relation }
      else
        format.html { render :new }
        format.json { render json: @artist_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artist_relations/1
  # PATCH/PUT /artist_relations/1.json
  def update
    respond_to do |format|
      if @artist_relation.update(artist_relation_params)
        format.html { redirect_to @artist_relation, notice: 'Artist relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist_relation }
      else
        format.html { render :edit }
        format.json { render json: @artist_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artist_relations/1
  # DELETE /artist_relations/1.json
  def destroy
    @artist_relation.destroy
    respond_to do |format|
      format.html { redirect_to artist_relations_url, notice: 'Artist relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist_relation
      @artist_relation = ArtistRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_relation_params
      params.require(:artist_relation).permit(:artist_id, :related_artist_id)
    end
end
