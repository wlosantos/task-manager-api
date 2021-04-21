class Api::V1::UsersController < ApplicationController

  def show
    begin
      user = User.find(params[:id])
      render json: user, status: :ok
    rescue
      head 404
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
