class Projectbundle < ActiveRecord::Base

  has_many :projects, dependent: :destroy
  has_many :signups, through: :projects
  has_many :enrollments, -> { distinct }, through: :projects, dependent: :destroy
  validates :name, presence: true
  validates :description, presence: true
  validates_uniqueness_of :active, :if => :active




  def to_s
    "#{name}"
  end

  def signup_is_active
    if self.signup_end < Date.today
      return false
    end
    true
  end

end
