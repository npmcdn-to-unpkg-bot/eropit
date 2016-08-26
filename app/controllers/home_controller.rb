class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
    @latest_articles = Article.where(published: true).order(created_at: :DESC)
    @popular_articles = Article.all
    @recommendations = Article.all
    @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)
  end
end
