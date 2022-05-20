class LoginController < ApplicationController

  def new
    render layout: false
  end

  def destroy
    logout!
    redirect_to new_login_path
  end

  def create
    username = Rails.application.credentials.username
    password = Rails.application.credentials.password

    success = [
      params[:username].present?,
      params[:password].present?,
      ActiveSupport::SecurityUtils.secure_compare(username, params[:username]),
      ActiveSupport::SecurityUtils.secure_compare(password, params[:password])
    ].all?

    if success
      login!
      redirect_to root_path
    else 
      flash[:error] = "Incorrect"
      render 'new', layout: false
    end
  end
end
