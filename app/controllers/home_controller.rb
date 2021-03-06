class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
    @latest_articles = Article.latest.published.page(params[:page])
    @popular_articles = Article.in_day.popular(6).published
    @recommendations = Article.tagged_with(ActsAsTaggableOn::Tag.most_used, :any => true).published.take(4)
    @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)
  end
end
