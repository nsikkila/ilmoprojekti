class Signup < ActiveRecord::Base
  belongs_to :project
  belongs_to :enrollment

  validates :student_id, presence: true
  validates :project_id, presence: true
end
