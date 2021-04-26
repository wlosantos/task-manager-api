class Api::V1::TasksController < ApplicationController

  before_action :authenticate_with_token!

  def index
    tasks = current_user.tasks.all
    render json: { tasks: tasks}, status: :ok
  end

end
