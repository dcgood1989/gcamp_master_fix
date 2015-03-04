class UsersController < ApplicationController

  before_action :ensure_current_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
      if @user.save
      flash[:notice] = "User was created successfully"
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
      flash[:notice] = "User was edited successfully"
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, notice: "The user has been successfully deleted"
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def ensure_current_user
    unless current_user
      flash[:error] = "You must sign in"
      redirect_to sign_in_path
    end
  end
end
