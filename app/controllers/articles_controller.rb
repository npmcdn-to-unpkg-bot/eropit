class ArticlesController < ApplicationController
  skip_before_action :basic_auth, only: [:show]

  def show
  end

  def new
    @category = Category.new
    @article = Article.new

    gon.available_tags = Article.tags_on(:tags).pluck(:name)
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

    gon.article_tags = @article.tag_list
    gon.available_tags = Article.tags_on(:tags).pluck(:name)
  end

  def update
    article = Article.find_by(id: params[:id])
    article.update_attributes article_params

    if article.save
      redirect_to article
    else
      render 'edit'
    end
  end

  def manage
    @category = Category.new
    @articles = Article.all
  end

  private
    def article_params
      params.require(:article).permit(:title, :description, :thumbnail, :link, :category_id, :duration, :host, :published, :tag_list)
    end
end
