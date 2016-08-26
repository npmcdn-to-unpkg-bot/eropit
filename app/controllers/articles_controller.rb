class ArticlesController < ApplicationController
  before_action :set_article_tags_to_gon, only: [:edit]
  before_action :set_available_tags_to_gon, only: [:new, :edit]

  skip_before_action :basic_auth, only: [:show]

  def show
  end

  def new
    @category = Category.new
    @article = Article.new
  end

  def create
    article = Article.new article_params

    if article.save
      redirect_to article
    else
      render 'new'
    end
  end

  def edit
    @category = Category.new
    @article = Article.find_by(id: params[:id])
  end

  def manage
    @category = Category.new
    @articles = Article.all
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :thumbnail, :link, :category_id, :duration, :host, :tag_list)
    end

    def set_article_tags_to_gon
      gon.article_tags = @article.tag_list unless @article.nil?
    end

    def set_available_tags_to_gon
      gon.available_tags = Article.tags_on(:tags).pluck(:name)
    end
end
