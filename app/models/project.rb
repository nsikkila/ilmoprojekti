class Project < ActiveRecord::Base
  validates :name, :allow_blank => false, length: {maximum: 100}
  validates :description,:allow_blank => false, length: {maximum: 10000}

  validates :website, url: true, :allow_blank => true
  #validointia ei asiakkaan mukaan tarvitse, yo. vaatii mukaan http://
  validates :maxstudents, :presence => true, :numericality => true

  has_one :projectpicture
  has_many :signups, dependent: :destroy
  has_many :enrollments, through: :signups
  belongs_to :projectbundle
  belongs_to :user
  accepts_nested_attributes_for :projectpicture

  def amount_of_accepted_students
    amount = 0
    signups.each do |signup|
      if signup.status
        amount = amount + 1
      end
    end
    amount
  end

end
