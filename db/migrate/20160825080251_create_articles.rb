class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :thumbnail
      t.text :description
      t.text :link
      t.integer :category_id
      t.boolean :published

      t.timestamps
    end
  end
end
