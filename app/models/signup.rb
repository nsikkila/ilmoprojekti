class Signup < ActiveRecord::Base
  belongs_to :project
  belogs_to :student
end
