class AddProjectpictureIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :projectpicture_id, :integer
  end
end
