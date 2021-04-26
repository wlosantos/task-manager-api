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

  def create
    task = current_user.tasks.build(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :done, :deadline)
  end

end
