class RemoveTimesFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :signup_start
    remove_column :projects, :signup_end
  end
end
