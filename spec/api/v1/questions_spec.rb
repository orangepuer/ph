require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get '/api/v1/questions', params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
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
end