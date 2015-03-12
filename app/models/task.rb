class Task < ActiveRecord::Base
  belongs_to :project
  validates :description, presence: true


  has_many :comments, through: :users
  has_many :comments
end
