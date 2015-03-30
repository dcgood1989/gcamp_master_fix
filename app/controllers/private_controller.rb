class PrivateController < ApplicationController
  helper_method :owner_count

  def owner_count(project)
    @project.memberships.where(roles:2).count
  end


end
