class AddProjectIdToProjectpicture < ActiveRecord::Migration
  def change
    add_column :projectpictures, :project_id, :integer
  end
end
