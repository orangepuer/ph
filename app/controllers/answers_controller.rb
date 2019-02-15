class AnswersController < ApplicationController
  before_action :set_question, only: :create
  before_action :authenticate_user!

  def create
    @answer = @question.answers.create(answer_params)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
