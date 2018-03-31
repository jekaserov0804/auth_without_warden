class SessionsController < ApplicationController
  def new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!
    redirect_to secret_path, notice: "Logged in!"
  end

  def destroy
    warden.logout
    redirect_to log_in_url, notice: "Logged out!"
  end
end
