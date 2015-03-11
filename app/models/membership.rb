class Membership < ActiveRecord::Base
belongs_to :project
belongs_to :user

validates :user, uniqueness: true
validates :user, presence: true

ROLE = ['Member', 'Owner']
end
