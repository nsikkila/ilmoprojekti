class Enrollment < ActiveRecord::Base

  has_many :signups
  accepts_nested_attributes_for :signups

  validates :firstname, length: {minimum: 2}
  validates :lastname, length: {minimum: 2}
  validates :studentnumber, format: {with: /\A[0-9]{7}\z/i}
  validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "has to be a valid email address"}

  def self.create_hash(enrollment)
    Digest::SHA1.hexdigest (enrollment.id.to_s + enrollment.created_at.to_s)
  end

end