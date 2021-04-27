class Api::V2::TasksController < ApplicationController

  before_action :authenticate_with_token!
  before_action :set_task, only: %i[ update destroy ]

  def index
    tasks = current_user.tasks.ransack(params[:q]).result
    render json: tasks, status: :ok
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

  def update
    if @task.update(task_params)
      render json: @task, status: 200
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def destroy
    @task.destroy
    head 204
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :done, :deadline)
  end

end
