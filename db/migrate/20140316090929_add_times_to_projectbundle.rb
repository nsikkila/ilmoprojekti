class AddTimesToProjectbundle < ActiveRecord::Migration
  def change
    add_column :projectbundles, :signup_start, :date
    add_column :projectbundles, :signup_end, :date
  end
end
