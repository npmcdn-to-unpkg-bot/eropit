class ArticlesController < ApplicationController
  skip_before_action :basic_auth, only: [:show, :ranking, :search, :favorites, :feed]
  before_action :set_sidebar_tags, only: [:show, :ranking, :search, :favorites]

  require 'fetch_video'

  def show
    @article = Article.find_by(id: params[:id])
    @related_articles = Article.related(@article.category_id, @article.id).published.limit(6)
    @recommendations = Article.tagged_with(ActsAsTaggableOn::Tag.most_used, :any => true).published.take(4)
    @title = @article.title
    create_view(@article.id)
  end

  def ranking
    @articles = Article.in_day.popular(20).published
    @title = '人気動画'
  end

  def search
    @articles = Article.tagged_with(params[:search]).published.page(params[:page])
    @title = "『#{ params[:search] }』の動画"
  end

  def favorites
    if params[:ids].present?
      ids = params[:ids].to_s.split(',')
      @favorite_articles = Article.where(id: ids).published.page(params[:page])
    else
      @favorite_articles = Article.where(id: 0).page(params[:page])
    end
    @title = 'お気に入り動画'
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

  def destroy
    article = Article.find_by(id: params[:id])
    if article.destroy
      redirect_to admin_path
    else
      redirect_to admin_path
    end
  end

  def manage
    @category = Category.new
    @articles = Article.all.page(params[:page])
    @title = 'Admin'
  end

  def feed
    @articles = Article.latest.published.limit(20)
    respond_to do |format|
      format.rss
    end
  end

  def fetch
    f = FetchVideo.new
    f.nukistream
    f.masutabe
    f.javym
    redirect_to admin_path
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

    def set_sidebar_tags
      @sidebar_tags = ActsAsTaggableOn::Tag.most_used(30)
    end
end
