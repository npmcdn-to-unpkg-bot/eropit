class ArticlesController < ApplicationController
  skip_before_action :basic_auth, only: [:show, :ranking, :search, :favorites]
  before_action :set_sidebar_tags, only: [:show, :ranking, :search, :favorites]

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

  def manage
    @category = Category.new
    @articles = Article.all.page(params[:page])
  end

  def nukistream
    url = 'http://www.nukistream.com'

    charset = nil
    html = open(url + '/category.php?id=27') do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    articles = doc.search('article')

    videos = []

    articles.each_with_index do |article, index|
      next if index == 0

      tags = []
      article.css('.article_content > ul > li').each do |tag|
        tags << tag.css('a').text
      end

      video = {}
      video[:thumbnail] = article.css('.thumb > a > img').attribute('src').value
      video[:duration] = article.css('.thumb > a > span').text
      video[:title] = article.css('.article_content > h3 > a').text
      video[:host] = 'ぬきスト'
      video[:link] = url + article.css('.thumb > a').attribute('href').value
      video[:tags] = tags
      videos << video
    end

    videos.each do |video|
      next if Article.exists?(link: video[:link])
      a = Article.new
      a.title = video[:title]
      a.thumbnail = video[:thumbnail]
      a.duration = video[:duration]
      a.host = video[:host]
      a.link = video[:link]
      a.tag_list.add(video[:tags])
      a.description = ''
      a.published = false
      a.category_id = 1
      a.save
    end

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
