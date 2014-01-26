class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.integer :student_id
      t.integer :project_id

      t.timestamps
    end
  end
end
