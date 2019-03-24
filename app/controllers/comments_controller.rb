class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent

  authorize_resource

  def create
    @comment = @parent.comments.new(comments_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def set_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end