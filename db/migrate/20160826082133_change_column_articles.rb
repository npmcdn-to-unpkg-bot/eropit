class ChangeColumnArticles < ActiveRecord::Migration[5.0]
  def change
    change_column_default :articles, :published, true
  end
end
