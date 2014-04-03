class AddSignupIndexBasedOnEnrollmentId < ActiveRecord::Migration
  def change
    add_index :signups, :enrollment_id
  end
end
