class AddColumnsToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :priority, :integer
    add_column :signups, :status, :boolean
  end
end
