require 'rails_helper'

RSpec.describe "Api::V2::Users", type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept': 'application/vnd.taskmanager.v2',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client']
    }
  end

  before { host! 'api.task-manager.dev' }

  describe 'GET /auth/validate_token' do

    context 'when the request header are valid' do
      before do
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'returns the user' do
        expect(json_body[:data][:id].to_i).to eq(user_id)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request header are invalid' do
      before do
        headers['access-token'] = 'invalid_token'
        get '/auth/validate_token', params: {}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /auth' do
    before do
      post '/auth', params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'return the json data users' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid@') }

      it 'returns the status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /auth' do
    before do
      put '/auth', params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { {email: 'wendel@admin.com'} }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data update user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid@' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns json data errors key' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before do
      delete '/auth', params: {}, headers: headers
    end

    context 'when delete users are valid' do
      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'removes the user from database' do
        expect( User.find_by_id(user.id)).to be_nil
      end
    end

  end
end
