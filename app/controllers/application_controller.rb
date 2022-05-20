class ApplicationController < ActionController::Base
  include Pagy::Backend

  private
  def ensure_logged_in
    if session[:user].nil?
      redirect_to new_login_path
    end
  end

  def login!
    session[:user] = :user
  end

  def logout!
    reset_session
  end
end
