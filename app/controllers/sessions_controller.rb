class SessionsController < ApplicationController
  def new
  end

  def create 
    #byebug
    user = User.find_by(email: params[:session][:email])

    if user and user.authenticate(params[:session][:password])
      log_in(user)
      #byebug
      if params[:session][:remember_me]=='1'
        remember(user)
      else
        forget(user)
      end
      #byebug
      redirect_back_or user
    else
      flash.now[:danger] = "We're sorry, that user already exists"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
