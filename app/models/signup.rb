class Signup < ActiveRecord::Base
  belongs_to :project
  belongs_to :enrollment

  #validates :project_id, presence: true

end
