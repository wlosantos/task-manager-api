class Api::V1::UsersController < ApplicationController

  def show
    begin
      user = User.find(params[:id])
      render json: user, status: :ok
    rescue
      head 404
    end
  end

end
