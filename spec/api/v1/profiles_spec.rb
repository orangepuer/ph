require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles', headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get '/api/v1/profiles', params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:users) { create_list(:user, 5) }
      let(:me) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user) { users.first }
      let(:users_response) { json['users'] }
      let(:user_response) { users_response.first }

      before { get '/api/v1/profiles', params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of user profiles without an authenticated user' do
        expect(users_response.size).to eq 4
      end

      %w(id email created_at updated_at admin).each do |attribute|
        it "contains #{attribute}" do
          expect(user_response[attribute]).to eq user.send(attribute).as_json
        end
      end

      %w(password encrypted_password).each do |attribute|
        it "does not contains #{attribute}" do
          expect(user_response).to_not have_key(attribute)
        end
      end
    end
  end

  describe 'GET #me' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers

        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token invalid' do
        get '/api/v1/profiles/me', params: {access_token: '123456'}, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['user'] }
      before { get '/api/v1/profiles/me', params: {access_token: access_token.token}, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      %w(id email created_at updated_at admin).each do |attribute|
        it "contain #{attribute}" do
          expect(user_response[attribute]).to eq me.send(attribute).as_json
        end
      end

      %w(password encrypted_password).each do |attribute|
        it "does not contain #{attribute}" do
          expect(json).to_not have_key(attribute)
        end
      end
    end
  end
end