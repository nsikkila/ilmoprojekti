class Project < ActiveRecord::Base
  validates :name, :allow_blank => false, length: {maximum: 100}
  validates :description,:allow_blank => false, length: {maximum: 10000}
  #validates :website, :url => true
  validates_format_of :website, :allow_blank => true, :with => URI::regexp(%w(http https))


  has_many :signups
  has_many :students, through: :signups
  belongs_to :projectbundle
  belongs_to :user
end
