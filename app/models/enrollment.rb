class Enrollment < ActiveRecord::Base

  has_many :signups
  accepts_nested_attributes_for :signups

<<<<<<< HEAD
  def initialize
    @msg = ""
  end

  
=begin
  def signups
    @signups
  end

  def signups=(signups)
    @signups = signups
  end

  def sfirstname
    @firstname
  end

  def sfirstname=(firstname)
    @sfirstname = firstname
  end

  def slastname=(lastname)
    @slastname = lastname
  end

  def studentnumber
    @studentnumber
  end

  def studentnumber=(studentnumber)
    @studentnumber = studentnumber
  end

  def email
    @email
  end

  def email=(email)
    @email = email
  end

  def msg
    @msg
  end

  def msg=(msg)
    @msg = msg
  end
=end
=======
  #validates :firstname, length: {minimum: 2}
  #validates :lastname, length: {minimum: 2}
 # validates_numericality_of :studentnumber, length: {minimum: 7}
  #validates :email, presence: {on: :create}, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i, message: "has to be a valid email address"}
>>>>>>> c459567e383c43f3074990a7a3a7115a0f010f65

end