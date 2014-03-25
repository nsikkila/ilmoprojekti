class AddForcedToSignup < ActiveRecord::Migration
  def change
    add_column :signups, :forced, :boolean
  end
end
