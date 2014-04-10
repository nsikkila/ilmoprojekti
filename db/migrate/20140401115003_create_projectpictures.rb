class CreateProjectpictures < ActiveRecord::Migration
  def change
    create_table :projectpictures do |t|
      t.column :filename, :string
      t.column :content_type, :string
      t.column :data, :binary
      t.timestamps
    end
  end
end