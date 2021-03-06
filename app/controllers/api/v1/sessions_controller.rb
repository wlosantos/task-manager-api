class Api::V1::SessionsController < Api::V1::BaseController

  def create
    user = User.find_by_email(session_params[:email])

    if user && user.valid_password?(session_params[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: 401
    end
  end

  def destroy
    user = User.find_by_auth_token(params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
