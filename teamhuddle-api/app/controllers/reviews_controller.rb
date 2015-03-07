class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @reviews = Review.includes(:user).where(sport_event_id: params[:id]).order(created_at: :asc)
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      render json: {review: @review, success: true}
    else
      render json: {success: false, errors: @review.errors}, status: 422
    end

  end

  private
  def review_params
    params.permit(:user_id, :sport_event_id, :rating, :review)
  end
end