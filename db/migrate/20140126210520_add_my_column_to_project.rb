class AddMyColumnToProject < ActiveRecord::Migration
  def change
    add_column :projects, :maxstudents, :integer
    add_column :projects, :user_id, :integer
    add_column :projects, :bundle_id, :integer
  end
end
