class SessionsController < ApplicationController
  def new
  end

  def create 
    #byebug
    user = User.find_by(email: params[:session][:email])

    if user and user.authenticate(params[:session][:password])
      if user.activated? 
        log_in user 
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Invalid email/password combo"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
