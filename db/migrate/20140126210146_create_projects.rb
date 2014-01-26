class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.date :signup_start
      t.date :signup_end

      t.timestamps
    end
  end
end
