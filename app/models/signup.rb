class Signup < ActiveRecord::Base
  belongs_to :project
  belongs_to :enrollment, autosave: true

  validates :project_id, presence: true

end
