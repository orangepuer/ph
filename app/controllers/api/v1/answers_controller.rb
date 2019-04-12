class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  def index
    render json: @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_resource_owner))

    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end