class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
    @film =Film.find_by(id: @review.film_id) 

  end

  # GET /reviews/new
  def new
    if logged_in?
      @review = Review.new
      @review.film_id= params.require(:format)
      @film =Film.find_by(id: @review.film_id) 
    else
      #redirect_to '/films'
      @film =Film.find_by(id: params.require(:format)) 
      redirect_to film_url(@film), notice: "You must login." 
    end
  end

  # GET /reviews/1/edit
  def edit
    if is_admin?
      @film =Film.find_by(id: @review.film_id) 
    elsif  @review.user_id==session[:user_id]
      @film =Film.find_by(id: @review.film_id) 
    else
      #redirect_to '/films'
      @film =Film.find_by(id: @review.film_id) 
      redirect_to film_url(@film), notice: "Your account does not have permission to perform this action." 
    end 

  end

  # POST /reviews or /reviews.json
  def create
    @cur=review_params
    @cur[:user_id]=session[:user_id]

    @review = Review.new(@cur)
    respond_to do |format|
    if @review.save
        @film =Film.find_by(id: @review.film_id) 

        format.html { redirect_to film_url(@film), notice: "Review was successfully created." }
        format.json { render :show, status: :ok, location: @film }
    else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        @film =Film.find_by(id: @review.film_id) 

        format.html { redirect_to film_url(@film), notice: "Review was successfully created." }
        format.json { render :show, status: :ok, location: @film }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    if is_admin?
      @film =Film.find_by(id: @review.film_id) 
      @review.destroy

      respond_to do |format|

          format.html { redirect_to film_url(@film), notice: "Review was successfully destroyed." }
          format.json { render :show, status: :ok, location: @film }

      end
    elsif  @review.user_id==session[:user_id]
      @film =Film.find_by(id: @review.film_id) 
      @review.destroy

      respond_to do |format|

          format.html { redirect_to film_url(@film), notice: "Review was successfully destroyed." }
          format.json { render :show, status: :ok, location: @film }

      end
    else
      #redirect_to '/films'
      @film =Film.find_by(id: @review.film_id) 
      redirect_to film_url(@film), notice: "Your account does not have permission to perform this action." 
    end 

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:description,:film_id)
    end
end
