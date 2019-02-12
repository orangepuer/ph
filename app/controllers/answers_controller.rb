class AnswersController < ApplicationController
  before_action :set_question, only: :create
  before_action :authenticate_user!

  def create
    @question.answers.create(answer_params)
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
