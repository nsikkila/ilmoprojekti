class UniqueSignupValidator < ActiveModel::Validator

  def validate(record)
    arr = Array.new
    at_least_one = false
    record.signups.each do |signup|
      if not signup.project_id.nil?
        at_least_one = true
        if arr.include?(signup.project_id)
          record.errors[:project] << 'Voit valita kunkin projektin vain kerran.'
        else
          arr << signup.project_id
        end
      end
    end

    if not at_least_one
      record.errors[:project] << 'Valitse vähintää yksi projekti.'
    end

  end
end

class Enrollment < ActiveRecord::Base
  belongs_to :projectbundle
  has_many :projects, through: :signups
  has_many :signups, -> { order(:id => :asc) }, dependent: :destroy
  accepts_nested_attributes_for :signups

  validates_with UniqueSignupValidator
  validates :firstname, length: {minimum: 2}
  validates :lastname, length: {minimum: 2}
  validates :studentnumber, format: {with: /\A[0-9]{7}\z/i, message: "Opiskelijanumeron täytyy olla numeroista koostuva ja 7 merkkiä pitkä"}
  validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "Sähköpostiosoitteen täytyy olla muotoa esi@merk.ki"}

  def name
    "#{lastname} #{firstname}"
  end

  def accepted_amount
    accepted = 0
    signups.each do |signup|
      if signup.status
        accepted = accepted + 1
      end
    end
    accepted
  end

  def magic_number2
    numba = self.signups.where(status:true).average('priority')
    if numba.nil?
      return 0
    else
      return numba.round(1)
    end
  end

  def magic_number
    number = 0
    amount = 0
    signups.each do |signup|
      if signup.status
        number = number + signup.priority
        amount = amount + 1
      end
    end
    #if amount == 0
     # return 0
    #end
    (number.to_f/amount).round(1)
  end

  def return_projectbundle
    self.projects.first.projectbundle
  end

  def self.create_hash(enrollment)
    Digest::SHA1.hexdigest (enrollment.id.to_s + enrollment.created_at.to_s)
  end
end