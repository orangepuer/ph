require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 5, user: user, question: question) }
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status code' do
        expect(response).to be_successful
      end

      it 'return list of answers' do
        expect(answers_response.size).to eq 5
      end

      %w(id body created_at updated_at).each do |attribute|
        it "answer object contain #{attribute}" do
          expect(answer_response[attribute]).to eq answer.send(attribute).as_json
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get "/api/v1/answers/#{answer.id}", params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 5, commentable: answer, user: user) }
      let!(:attachments) { create_list(:attachment, 4, attachmentable: answer) }
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get "/api/v1/answers/#{answer.id}", params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      %w(id body created_at updated_at).each do |attribute|
        it "answer object contains #{attribute}" do
          expect(answer_response[attribute]).to eq answer.send(attribute).as_json
        end
      end

      context 'comments' do
        let(:comment) { comments.first }
        let(:comments_response) { answer_response['comments'] }
        let(:comment_response) { comments_response.last }

        it 'included in question object' do
          expect(comments_response.size).to eq 5
        end

        %w(id body created_at updated_at).each do |attribute|
          it "contain #{attribute}" do
            expect(comment_response[attribute]).to eq comment.send(attribute).as_json
          end
        end
      end

      context 'attachments' do
        let(:attachment) { attachments.first }
        let(:attachments_response) { answer_response['attachments'] }
        let(:attachment_response) { attachments_response.first }

        it 'included in answer object' do
          expect(attachments_response.size).to eq 4
        end

        %w(id created_at updated_at).each do |attribute|
          it "contain #{attribute}" do
            expect(attachment_response[attribute]).to eq attachment.send(attribute).as_json
          end
        end

        it "contain links" do
          expect(attachment_response['file']['url']).to eq attachment.file.url.as_json
        end
      end
    end
  end

  describe 'GET #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer) }

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: '123456', answer: attributes_for(:answer) }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'return 200 status' do
          post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                     answer: attributes_for(:answer),
                                                                     format: :json }

          expect(response).to be_successful
        end

        it 'save the new answer in the database' do
          expect do
            post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                       answer: attributes_for(:answer),
                                                                       format: :json }
          end.to change(Answer, :count).by(1)
        end

        it 'save the new answer with correct attributes' do
          post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                     answer: { body: 'new_body' },
                                                                     format: :json }

          expect(question.answers.last.body).to eq 'new_body'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token,
                                                                       answer: attributes_for(:invalid_answer),
                                                                       format: :json }
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end