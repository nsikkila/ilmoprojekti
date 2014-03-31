
=begin
class UniqueSActiveValidator < ActiveModel::Validator

  def validate(record)
    projectbundle =  Projectbundle.find_by_active(true)
    #jos löytyi aktiivinen projektbundle ja record on aktiivinen ja record ei vastaa löydettyä aktiivista
      if not projectbundle.nil? and record.active? and record.id != projectbundle.id and not record.id.nil?
        record.errors[:projectbundle] <<"Vain yksi projektiryhmä voi olla kerrallaan aktiivinen"
      end

    #jos record on uusi projectbundle ja se on aktiivinen ja kannasta löytyi aktiivinen
        if record.id.nil? and record.active? and not projectbundle.nil?
          record.errors[:projectbundle] <<"Vain yksi projektiryhmä voi olla kerrallaan aktiivinen"
        end
     end
end
=end


class Projectbundle < ActiveRecord::Base
  has_many :projects
  has_many :signups, through: :projects
  has_many :enrollments, -> { distinct }, through: :projects
  validates :name, presence: true
  validates :description, presence: true
  #validates_with UniqueSActiveValidator
  #validates_uniqueness_of :active, conditions: -> { where.not(active: false) }
  #validates_uniqueness_of :name
  validates_uniqueness_of :active, :if => :active



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
