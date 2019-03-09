require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  describe 'Post#create' do
    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, user: @user, question: question) }

    it 'loads question if parent question' do
      post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
      expect(assigns(:parent)).to eq question
    end

    it 'loads answer if parent answer' do
      post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :js }
      expect(assigns(:parent)).to eq answer
    end
  end
end