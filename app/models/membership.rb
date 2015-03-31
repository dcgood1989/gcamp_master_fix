class Membership < ActiveRecord::Base
belongs_to :project
belongs_to :user

validates :user, uniqueness: {scope: :project_id, message: 'has already been added to this project'}
validates :user, presence: true




  def membership_content(membership)
    if membership.roles == 2
      "Owner"
    else
      "Member"
    end
  end


end
