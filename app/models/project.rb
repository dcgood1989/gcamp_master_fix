class Project < ActiveRecord::Base
  has_many :tasks
  has_many :users, through: :memberships
  has_many :memberships
  validates :name, presence: true
end
