class FilmsController < ApplicationController
  before_action :set_film, only: %i[ show edit update destroy ]

  # GET /films or /films.json
  def index

    
    puts session[:user_id]
    @films = Film.all
  end

  # GET /films/1 or /films/1.json
  def show
    @film=Film.find(params[:id])
    
  end

  # GET /films/new
  def new
    
    if is_admin?
      @film = Film.new
    else
      #redirect_to '/films'
      @films = Film.all

      respond_to do |format|
        format.html { redirect_to (films_path), notice: "You must be an admin." }
        format.json { render :show, status: :fail, location: @films }
      end
    end

  end

  # GET /films/1/edit
  def edit
    @film=Film.find(params[:id])
    if is_admin?
      @film=Film.find(params[:id])
    else
      #redirect_to '/films'
      @films = Film.all

      respond_to do |format|
        format.html { redirect_to (films_path), notice: "You must be an admin." }
        format.json { render :show, status: :fail, location: @films }
      end
    end
  end

  # POST /films or /films.json
  def create
    @film = Film.new(film_params)
    respond_to do |format|
      if @film.save
        format.html { redirect_to film_path(@film), notice: "Film was successfully created." }
        format.json { render :show, status: :created, location: @film }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /films/1 or /films/1.json
  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to film_url(@film), notice: "Film was successfully updated." }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1 or /films/1.json
  def destroy
    if is_admin?
      @film=Film.find(params[:id])
    else
      #redirect_to '/films'
      @films = Film.all

      respond_to do |format|
        format.html { redirect_to (films_path), notice: "You must be an admin." }
        format.json { render :show, status: :fail, location: @films }
      end
    end

    puts @film.id

    @reviews =Review.where(:film_id => @film.id )

    
    @reviews.each do |review|
      review.destroy
    end
    @film.destroy
    respond_to do |format|
      format.html { redirect_to films_url, notice: "Film was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_film
      @film = Film.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def film_params
      params.require(:film).permit(:name, :director, :year)
    end
end
