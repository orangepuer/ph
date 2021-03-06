class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :authenticate_user!, except: [:index, :show]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.attachments.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
      ActionCable.server.broadcast "/questions", question: @question
    else
      render :new
    end
  end

  def update
    if @question.user == current_user
      @question.update(question_params)
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'You question successfully deleted'
  end

  def subscribe
    @question.subscriptions.create(user: current_user) unless find_subscription
    redirect_to @question
  end

  def unsubscribe
    find_subscription.destroy if find_subscription
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def find_subscription
    @subscription = current_user.subscriptions.find_by(question_id: @question)
  end
end
