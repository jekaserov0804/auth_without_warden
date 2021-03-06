class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def authorize
    redirect_to log_in_url, notice: 'Non authorize' if current_user.nil?
  end
end
