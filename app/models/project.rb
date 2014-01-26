class Project < ActiveRecord::Base
  has_many :signups
  has_many :students, through: :signups
  belongs_to :user
end
