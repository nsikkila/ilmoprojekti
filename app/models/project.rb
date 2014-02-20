class Project < ActiveRecord::Base
  validates :name, :allow_blank => false, length: {maximum: 100}
  validates :description,:allow_blank => false, length: {maximum: 10000}
  has_many :signups
  has_many :students, through: :signups
  belongs_to :projectbundle
  belongs_to :user
end
