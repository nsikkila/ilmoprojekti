class Student < ActiveRecord::Base
  has_many :signups

  validates :firstname, length: {minimum: 2}
  validates :lastname, length: {minimum: 2}
  validates :studentnumber, length: {minimum: 7}
  validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "has to be a valid email address"}

end
