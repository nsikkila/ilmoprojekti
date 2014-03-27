class Projectbundle < ActiveRecord::Base
  has_many :projects
  has_many :signups, through: :projects
  has_many :enrollments, through: :projects
  validates :name, presence: true
  validates :description, presence: true

  def to_s
    "#{name}"
  end

  def is_signup_active
    if self.signup_end < Date.today
      return false
    end
    true
  end
end
