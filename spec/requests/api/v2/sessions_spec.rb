require 'rails_helper'

RSpec.describe 'Session API', type: :request do
  before { host! 'api.task-manager.dev' }
  let(:user) { create(:user) }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept': 'application/vnd.taskmanager.v2',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client']
    }
  end

  describe 'POST /auth/sign_in' do
    before { post '/auth/sign_in', params: credentials.to_json, headers: headers }

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the authentication data in the header' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: '12345678' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the errors with auth token' do
        expect(json_body).to have_key(:errors)
      end
    end

  end

  describe 'DELETE /auth/sign_out' do
    let(:auth_token) { user.auth_token }
    before { delete '/auth/sign_out', params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'changes the user auth token' do
      user.reload
      # expect(user.valid_token?(auth_data['access-token'], auth_data['client'])).to eq(false)
      expect(user).not_to be_valid_token(auth_data['access-token'], auth_data['client'])
    end
  end
end
