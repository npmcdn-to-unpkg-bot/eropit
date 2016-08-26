class Article < ApplicationRecord
  acts_as_taggable

  scope :related, ->(category_id, article_id) {
    where(category_id: category_id)
    .where.not(id: article_id)
    .limit(12)
  }
  scope :published, -> { where(published: true) }
end
