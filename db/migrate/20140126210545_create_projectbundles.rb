class CreateProjectbundles < ActiveRecord::Migration
  def change
    create_table :projectbundles do |t|
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
