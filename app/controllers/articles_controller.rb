class ArticlesController < ApplicationController
  skip_before_action :basic_auth, only: [:show]

  def show
  end

  def manage
    @articles = Article.all
  end
end
