class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
    @latest_articles = Article.latest.published
    @popular_articles = Article.in_day.popular(12).published
    @recommendations = Article.tagged_with(ActsAsTaggableOn::Tag.most_used, :any => true).limit(3)
    @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)
    @title = 'トップ'
  end
end
