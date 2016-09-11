class AddColumnsToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :mean, :string, default: ''
    add_column :tags, :pre_words, :string, default: ''
    add_column :tags, :suf_words, :string, default: ''
  end
end
