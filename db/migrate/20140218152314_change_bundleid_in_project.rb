class ChangeBundleidInProject < ActiveRecord::Migration
  def change
    rename_column :projects, :bundle_id, :projectbundle_id
  end
end
