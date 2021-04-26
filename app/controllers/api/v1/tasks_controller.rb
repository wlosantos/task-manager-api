class Api::V1::TasksController < ApplicationController

  before_action :authenticate_with_token!

  def index
    tasks = current_user.tasks.all
    render json: { tasks: tasks}, status: :ok
  end

  def show
    begin
      task = current_user.tasks.find_by(id: params[:id])
      render json: task, status: :ok
    rescue
      head 404
    end
  end

end
