class AnswersController < ApplicationController
  before_action :set_question, only: :create
  before_action :authenticate_user!

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      if @answer.save
        format.js
        ActionCable.server.broadcast "/questions/#{@question.id}", answer: @answer, attachments: @answer.get_attachments
      else
        format.js
      end
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user == current_user
      @answer.update(answer_params)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
