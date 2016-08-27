class ArticlesController < ApplicationController
  skip_before_action :basic_auth, only: [:show]

  def show
    @article = Article.find_by(id: params[:id])
    @related_articles = Article.related(@article.category_id, @article.id).published
    @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)

    create_view(@article.id)
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

    def create_view(article_id)
      v = View.new
      v.article_id = article_id
      v.save!
    end
end
