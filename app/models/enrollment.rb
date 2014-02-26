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

  has_many :signups, order:'id ASC'
  accepts_nested_attributes_for :signups

  validates_with UniqueSignupValidator
  validates :firstname, length: {minimum: 2}
  validates :lastname, length: {minimum: 2}
  validates :studentnumber, format: {with: /\A[0-9]{7}\z/i, message: "Opiskelijanumeron täytyy olla numeroista koostuva ja 7 merkkiä pitkä"}
  validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "Sähköpostiosoitteen täytyy olla muotoa esi@merk.ki"}

  def self.create_hash(enrollment)
    Digest::SHA1.hexdigest (enrollment.id.to_s + enrollment.created_at.to_s)
  end

end
