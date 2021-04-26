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

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user: user) }
    before do
      get "/tasks/#{task.id}", params: {}, headers: headers
    end

    context 'when returns successfuly' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json for task' do
        expect(json_body[:title]).to eq(task.title)
      end
    end

  end

end
