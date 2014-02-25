class UniqueSignupValidator < ActiveModel::Validator

  def validate(record)
    arr = Array.new
    record.signups.each do | signup |
      if arr.include?(signup.project_id)
        record.errors[:project] << 'can only have one priority'
      else
        arr << signup.project_id
      end
    end
  end

end

class Enrollment < ActiveRecord::Base

  has_many :signups
  accepts_nested_attributes_for :signups

  validates_with UniqueSignupValidator
  validates :firstname, length: {minimum: 2}
  validates :lastname, length: {minimum: 2}
  validates :studentnumber, format: {with: /\A[0-9]{7}\z/i}
  validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "has to be a valid email address"}

end
