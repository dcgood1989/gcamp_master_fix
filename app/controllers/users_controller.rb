class UsersController < PrivateController
  helper_method :project_members
  before_action :ensure_current_user
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :cant_edit_other_users, only: [:edit, :update, :destroy]

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
    # if params.admin == true && current_user.admin
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
    if user == current_user && user.destroy
      redirect_to root_path, notice: "User was successfully deleted"
    else
      redirect_to users_path, notice: "User was successfully deleted"
    end
  end

private

  def user_params
    if current_user.admin
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin, :pivotal_tracker_token)
    else
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :pivotal_tracker_token)
    end
  end


  def ensure_current_user
    unless current_user
      session[:previous_page] = request.fullpath
      flash[:error] = "You must sign in"
      redirect_to sign_in_path
    end
  end

  def cant_edit_other_users
    unless current_user.admin == true
      if current_user != @user
        render file: 'public/404.html', status: :not_found, layout: false
      else
        current_user.admin
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def membership(project)
    self.memberships.find_by(project_id: project.id) != nil
  end

  def membership_owner_or_admin(project)
    self.memberships.where(project_id: project.id).roles == 2 || self.admin
  end



end
