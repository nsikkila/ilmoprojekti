class Projectbundle < ActiveRecord::Base
  has_many :projects
  has_many :signups, through: :projects
  has_many :enrollments, -> { distinct }, through: :projects
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

  def self.to_csv
    @bundle = Projectbundle.find_by_active(true)
    csv_array = [" ", "Opiskelija", "Opiskelijanumero"]
    @bundle.projects.each do |pro|
      csv_array << pro.name
    end
    csv_array << "Opiskelijalla projekteja"
    csv_array << "Magic number"

    csv_string = CSV.generate do |csv|
      csv << csv_array
      @bundle.enrollments.each do |enroll|
        csv_enroll = [enroll.name]
        enroll.signups.each do |sign|

        end
        csv << csv_enroll
      end
    end

    csv_string
  end
end
