require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
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
end