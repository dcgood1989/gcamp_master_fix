class MembershipsController < PrivateController
  helper_method :ensure_last_owner
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :logged_in_users_without_access, only:[:edit, :update, :destroy]
  before_action :verify_membership, except: [:new, :create, :index]
  before_action :verify_owner, only: [:edit]
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
    params.require(:membership).permit(:roles, :user_id, :project_id)
  end

  def logged_in_users_without_access
    if !current_user.memberships.pluck(:project_id).include?(@project.id)
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

end
