class UsersController < ApplicationController
  before_action :set_user, only: :finish_signup

  def finish_signup
    return unless request.patch? && params.dig(:user, :email)

    head @user.update!(user_params) ? :ok : :bad_request
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
