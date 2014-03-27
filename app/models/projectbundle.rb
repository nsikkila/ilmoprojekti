
class UniqueSActiveValidator < ActiveModel::Validator


  def validate(record)
    if record.active?
    projectbundles = Projectbundle.all
    at_least_one_true = false
    projectbundles.each do |projectbundle|
      if projectbundle.active?
        at_least_one_true = true
      end
    end
    if at_least_one_true
      record.errors[:projectbundle] <<"Vain yksi projektiryhmä voi olla kerrallaan aktiivinen"
    end
end
end
end

class Projectbundle < ActiveRecord::Base
  has_many :projects
  has_many :signups, through: :projects
  has_many :enrollments, -> { distinct }, through: :projects
  validates :name, presence: true
  validates :description, presence: true
  #validates_with UniqueSActiveValidator



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
