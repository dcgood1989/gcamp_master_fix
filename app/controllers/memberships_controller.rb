class MembershipsController < PrivateController

  before_action do
    @project = Project.find(params[:project_id])
  end

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
    @project = Project.find(params[:project_id])
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
    redirect_to project_memberships_path(@project.id)
    flash[:notice] = "#{membership.user.full_name} was successfully deleted"
  end

private

  def membership_params
    params.require(:membership).permit(:roles, :user_id, :project_id)
  end



end
