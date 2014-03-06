class Project < ActiveRecord::Base
  validates :name, :allow_blank => false, length: {maximum: 100}
  validates :description,:allow_blank => false, length: {maximum: 10000}
  #validates :website, :url => true
  #validates :website, format: {with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/i, message: "testi"}

  #validates_format_of :website, :with => URI::regexp(%w(http https))
  validates :website, url: true, :allow_blank => true
  validates :maxstudents, :presence => true, :numericality => true

  has_many :signups
  has_many :students, through: :signups
  belongs_to :projectbundle
  belongs_to :user
end
