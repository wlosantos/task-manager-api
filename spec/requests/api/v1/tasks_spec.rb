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

  describe 'POST /tasks' do
    let(:task) { create(:task, user: user) }
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end

    context 'when the params is valid' do
      let(:task_params) { attributes_for(:task) }

      it 'returns the status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'save the task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
      it 'returns the json for created task' do
        expect(json_body[:title]).to eq(task_params[:title])
      end
      it 'assigns the created task to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when the params is invalid' do
      let(:task_params) { attributes_for(:task, title: '') }

      it 'returns the status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'does not save the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end
      it 'returns the json task error' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, user: user) }
    before { put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers }

    context 'when the params are valid' do
      let(:task_params) { { title: 'tasks successfuly' } }

      it 'returns the status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'return the json data to the task' do
        expect(json_body[:title]).to eq(task_params[:title])
      end
      it 'updates the task int the database' do
        expect(Task.find_by_title(task_params[:title])).to_not be_nil
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { { title: ' '} }

      it 'returns the status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns the json data errors task' do
        expect(json_body[:errors]).to have_key(:title)
      end
      it 'does not update the task in the database' do
        expect(Task.find_by_title(task_params[:title])).to be_nil
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let!(:task) { create(:task, user: user) }
    before { delete "/tasks/#{task.id}", params: {}, headers: headers }

    it 'returns the status code 204' do
      expect(response).to have_http_status(204)
    end
    it 'remove the task in the database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
