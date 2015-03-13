class Task < ActiveRecord::Base
  belongs_to :project
  validates :description, presence: true


  has_many :comments, through: :users, dependent: :destroy
  has_many :comments, dependent: :destroy
end
