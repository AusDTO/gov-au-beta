class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new(url: request.referrer)
    @form = FeedbackForm.new(@feedback)
  end

  def create
    @form = FeedbackForm.new(Feedback.new)
    if @form.validate(feedback_params)
      @form.save
      @feedback = @form.model
    else
      render :new
    end
  end

  private
    def feedback_params
      params.require(:feedback).permit(:url, :email, :comment)
    end
end
