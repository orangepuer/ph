require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET #index' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:questions) { create_list(:question, 4, user: user) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 5, user: user, question: question) }
      let(:question_response) { json['questions'].first }

      before { get '/api/v1/questions', params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status code' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 4
      end

      %w(id title body created_at updated_at).each do |attribute|
        it "question object contain #{attribute}" do
          expect(question_response[attribute]).to eq question.send(attribute).as_json
        end
      end

      it 'question object contain short title' do
        expect(question_response['short_title']).to eq question.title.truncate(5)
      end

      context 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'included in question object' do
          expect(question_response['answers'].size).to eq 5
        end

        %w(id body created_at updated_at).each do |attribute|
          it "answer object contains #{attribute}" do
            expect(answer_response[attribute]).to eq answer.send(attribute).as_json
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get "/api/v1/questions/#{question.id}", params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:comments) { create_list(:comment, 5, commentable: question, user: user) }
      let!(:attachments) { create_list(:attachment, 4, attachmentable: question) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      %w(id title body created_at updated_at).each do |attribute|
        it "question object contains #{attribute}" do
          expect(question_response[attribute]).to eq question.send(attribute).as_json
        end
      end

      it 'question object contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(5)
      end

      context 'comments' do
        let(:comment) { comments.first }
        let(:comments_response) { question_response['comments'] }
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
        let(:attachments_response) { question_response['attachments'] }
        let(:attachment_response) { attachments_response.first }

        it 'included in question object' do
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
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        post "/api/v1/questions/", params: { question: attributes_for(:question) }

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        post "/api/v1/questions/", params: { access_token: '123456', question: attributes_for(:question) }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'return 200 status' do
          post "/api/v1/questions/", params: { access_token: access_token.token,
                                               question: attributes_for(:question),
                                               format: :json }

          expect(response).to be_successful
        end

        it 'save the new question in the database' do
          expect do
            post "/api/v1/questions", params: { access_token: access_token.token,
                                                question: attributes_for(:question),
                                                format: :json }
          end.to change(Question, :count).by(1)
        end

        it 'save the new question with correct attributes' do
          post "/api/v1/questions/", params: { access_token: access_token.token,
                                               question: { title: 'new_title', body: 'new_body' },
                                               format: :json }

          expect(Question.last.title).to eq 'new_title'
          expect(Question.last.body).to eq 'new_body'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post "/api/v1/questions/", params: { access_token: access_token.token,
                                                 question: attributes_for(:invalid_question),
                                                 format: :json }
          end.to_not change(Question, :count)
        end
      end
    end
  end
end