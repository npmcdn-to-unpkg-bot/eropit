class ArticlesController < ApplicationController
  before_action :set_article_tags_to_gon, only: [:edit]
  before_action :set_available_tags_to_gon, only: [:new, :edit]

  skip_before_action :basic_auth, only: [:show]

  def show
  end

  def new
    @article = Article.new
  end

  def manage
    @articles = Article.all
  end

  private
    def article_params
      params.require(:article).permit(:tag_list)
    end

    def set_article_tags_to_gon
      gon.article_tags = @article.tag_list
    end

    def set_available_tags_to_gon
      gon.available_tags = Article.tags_on(:tags).pluck(:name)
    end
end
