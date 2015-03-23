class ProjectsController < PrivateController
  before_action :ensure_current_user
  # before_action :ensure_project_member

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @user = current_user
    if @project.save
      flash[:notice] = "Project was created successfully"
      redirect_to project_tasks_path(@project)
      @project.memberships.create!(roles: 2, user_id: @user.id)
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_path(@project)
      flash[:notice] = "Project was edited successfully"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: "The project has been successfully deleted"
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def ensure_current_user
    unless current_user
      flash[:error] = "You must sign in"
      redirect_to sign_in_path
    end
  end

  # # def ensure_project_member
  # #   if current_user.project == true
  # #     redirect_to root_path
  # #   else
  # #     flash[:error] = ""
  # # end
  #
  #
  #
  # end



end
