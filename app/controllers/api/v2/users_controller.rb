class Api::V2::UsersController < ApplicationController

  before_action :set_users, only: %i[ update destroy ]
  before_action :authenticate_with_token!, only: %i[ update destroy ]

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

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private

  def set_users
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
