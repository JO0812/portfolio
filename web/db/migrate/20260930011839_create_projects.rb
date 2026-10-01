class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :repository_url

      t.timestamps
    end
  end
end
