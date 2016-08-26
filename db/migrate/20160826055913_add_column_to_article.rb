class AddColumnToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :duration, :string
    add_column :articles, :host, :string
  end
end
