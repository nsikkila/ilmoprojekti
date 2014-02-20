class ChangeStudentidToEnrollmentidInSignups < ActiveRecord::Migration
  def change
    rename_column :signups, :student_id, :enrollment_id
  end
end
