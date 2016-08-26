class Article < ApplicationRecord
  has_many :views

  acts_as_taggable

  scope :related, ->(category_id, article_id) {
    where(category_id: category_id)
    .where.not(id: article_id)
    .limit(12)
  }
  scope :popular, -> {
    joins(:views)
    .order('count(views.id) desc')
    .group('articles.id')
    .limit(12)
  }
  scope :in_day, -> { where('views.created_at BETWEEN ? AND ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day) }
  scope :latest, -> { order(created_at: :DESC) }
  scope :published, -> { where(published: true) }
end
