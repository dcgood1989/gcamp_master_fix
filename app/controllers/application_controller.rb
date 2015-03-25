class ApplicationController < ActionController::Base
helper_method :current_user
  protect_from_forgery with: :exception


  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end

  # def verify_membership
  #   if current_user.membership.project == false
  #     flash[:error] = "You do not have access to that project"
  #     redirect_to projects_path
  #   end
  # end

end
