class ChangeDateFormatInProjectbundles < ActiveRecord::Migration
  def change
	change_column :projectbundles, :signup_start, :datetime
	change_column :projectbundles, :signup_end, :datetime
  end
end
