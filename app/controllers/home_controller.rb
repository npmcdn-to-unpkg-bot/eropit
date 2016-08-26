class HomeController < ApplicationController
  skip_before_action :basic_auth, only: [:index]

  def index
    @latest_articles = Article.where(published: true).order(created_at: :DESC)
  end
end
