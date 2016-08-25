class CreateViews < ActiveRecord::Migration[5.0]
  def change
    create_table :views do |t|
      t.integer :article_id

      t.timestamps
    end
  end
end
