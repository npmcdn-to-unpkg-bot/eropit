class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
    @latest_articles = Article.latest.published
    @popular_articles = Article.in_day.popular.published
    @recommendations = Article.tagged_with(ActsAsTaggableOn::Tag.most_used, :any => true)
    @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)
  end
end
