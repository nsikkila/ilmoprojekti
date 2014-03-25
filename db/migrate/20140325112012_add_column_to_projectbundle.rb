class AddColumnToProjectbundle < ActiveRecord::Migration
  def change
    add_column :projectbundles, :verified, :boolean
  end
end
