class AuthenticationController < ApplicationController

  def new
    @user = User.new

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Successfully signed in"
      redirect_to '/'
    else
      @authentication_error = "Email/Password combination is invalid"
      render :new
    end
  end

end
