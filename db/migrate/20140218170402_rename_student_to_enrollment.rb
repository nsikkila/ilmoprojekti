class RenameStudentToEnrollment < ActiveRecord::Migration

  def change
    rename_table :students, :enrollments
  end

end