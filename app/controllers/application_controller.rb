class ApplicationController < ActionController::Base
  before_action :ensure_signup_complete
  before_action :gon_user

  def ensure_signup_complete
    return if action_name == 'finish_signup' || action_name == 'show' && controller_name == 'confirmations'

    redirect_to finish_signup_path(current_user) if user_signed_in? && !current_user.email_verified?
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

end
