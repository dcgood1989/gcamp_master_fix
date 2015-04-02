class MembershipsController < PrivateController
  helper_method :ensure_last_owner
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :ensure_current_user
  before_action :logged_in_users_without_access, only:[:edit, :update, :destroy]
  before_action :verify_owner, only: [:edit, :update, :destroy, :index]
  before_action :verify_membership, except: [:new, :create, :index, :destroy]
  before_action :ensure_last_owner, only: [:update, :destroy]


  def index
    @membership = @project.memberships.new
  end

  def create
    @membership = @project.memberships.new(membership_params)
    if @membership.save
      flash[:notice] = "#{@membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(@project.id)
    else
      render :index
    end
  end

  def update
    membership = @project.memberships.find(params[:id])
    if membership.update(membership_params)
      redirect_to project_memberships_path, notice: "#{membership.user.full_name} was successfully updated"
    else
      redirect_to project_memberships_path(@project)
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    redirect_to projects_path
    flash[:notice] = "#{membership.user.full_name} was successfully deleted"
  end

private

  def membership_params
    if current_user.admin
      params.require(:membership).permit(:roles, :user_id, :project_id)
    else
      params.require(:membership).permit(:roles, :user_id, :project_id)
    end
  end

  def logged_in_users_without_access
    unless current_user.memberships.pluck(:project_id).include?(@project.id) || current_user.admin
      flash[:error] = "You do not have access"
      redirect_to project_path(@project)
    end
  end

  def ensure_last_owner
    membership = @project.memberships.find(params[:id])
      if membership.present?
        if membership.roles == 2 && @project.memberships.where(roles: 2).count == 1
          flash[:error] = "Projects must have at least one owner"
          redirect_to project_memberships_path(@project)
        end
      end
    end

    def ensure_current_user
      unless current_user
        session[:previous_page] = request.fullpath
        flash[:error] = "You must sign in"
        redirect_to sign_in_path
      end
    end




end
