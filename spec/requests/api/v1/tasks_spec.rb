require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  before { host! 'api.task-manager.dev' }
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Content-Type': Mime[:json].to_s,
      'Accept': 'application/vnd.taskmanger.v1',
      'Authorization': user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user: user)
      get '/tasks', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    it 'returns 5 tasks from database' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

end
