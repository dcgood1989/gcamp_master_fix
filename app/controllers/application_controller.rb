class ApplicationController < ActionController::Base
helper_method :current_user, :project_members
  protect_from_forgery with: :exception


  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end

  def verify_membership
    unless current_user.membership(@project) || current_user.admin
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def verify_owner
     unless current_user.membership_owner_or_admin(@project) || current_user.admin
       flash[:error] = "You do not have access to that project"
       redirect_to project_path(@project)
     end
   end

   def set_project
     @project = Project.find(params[:id])
   end

   def membership_owner_or_admin(project)
     self.memberships.where(project_id: project.id, roles: 2).present? || self.admin
   end

   def project_members(user1, user2)
     unless user2.projects.where(id: user1.projects) == []
       true
     end
   end
end
