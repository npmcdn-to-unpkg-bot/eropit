class FetchVideo
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
      #video[:title] = article.css('.article_content > h3 > a').text
      video[:host] = 'ぬきスト'
      video[:link] = url + article.css('.thumb > a').attribute('href').value
      video[:tags] = tags
      videos << video
    end

    save(videos)
  end

  def javym
    url = 'http://javym.net'

    charset = nil
    html = open(url + '/search/%E3%83%8A%E3%83%B3%E3%83%91/') do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    articles = doc.search('article')

    videos = []

    articles.each_with_index do |article, index|
      next if index == 0

      tags = []
      article.css('.tagList > li').each do |tag|
        tags << tag.css('a').text
      end

      video = {}
      video[:thumbnail] = article.css('figure > img').attribute('src').value
      video[:duration] = article.css('figure > .duration').text
      #video[:title] = article.css('.article_content > h3 > a').text
      video[:host] = 'ジャビま'
      video[:link] = url + article.css('h2 > a').attribute('href').value
      video[:tags] = tags
      videos << video
    end

    save(videos)
  end

  def masutabe
    url = 'http://masutabe.info'

    charset = nil
    html = open(url + '/search/%E3%83%8A%E3%83%B3%E3%83%91/') do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    articles = doc.search('article')

    videos = []

    articles.each_with_index do |article, index|
      next if index == 0

      tags = []
      article.css('.tagList > li').each do |tag|
        tags << tag.css('a').text
      end

      video = {}
      video[:thumbnail] = article.css('figure > a > img').attribute('src').value
      video[:duration] = article.css('figure > a > .duration').text
      #video[:title] = article.css('.info > h2 > a').text
      video[:host] = 'マスタベ'
      video[:link] = url + article.css('figure > a').attribute('href').value
      video[:tags] = tags
      videos << video
    end

    save(videos)
  end

  def save(videos)
    videos.each do |video|
      next if Article.exists?(link: video[:link])
      a = Article.new
      a.title = generate_title
      a.thumbnail = video[:thumbnail]
      a.duration = video[:duration]
      a.host = video[:host]
      a.link = video[:link]
      a.tag_list.add(video[:tags])
      a.description = ''
      a.published = true
      a.category_id = 1
      a.save
    end
  end

  def generate_title
    @b_tags = ActsAsTaggableOn::Tag.where(mean: 'b').pluck(:name, :pre_words, :suf_words)
    @c_tags = ActsAsTaggableOn::Tag.where(mean: 'c').pluck(:name, :pre_words, :suf_words)
    @i_tags = ActsAsTaggableOn::Tag.where(mean: 'i').pluck(:name, :pre_words, :suf_words)
    @d_tags = ActsAsTaggableOn::Tag.where(mean: 'd').pluck(:name, :pre_words, :suf_words)
    @pp_tags = ActsAsTaggableOn::Tag.where(mean: 'pp').pluck(:name, :pre_words, :suf_words)
    @ap_tags = ActsAsTaggableOn::Tag.where(mean: 'ap').pluck(:name, :pre_words, :suf_words)
    @s_tags = ActsAsTaggableOn::Tag.where(mean: 's').pluck(:name, :pre_words, :suf_words)
    @o_tags = ActsAsTaggableOn::Tag.where(mean: 'o').pluck(:name, :pre_words, :suf_words)
    @v_tags = ActsAsTaggableOn::Tag.where(mean: 'v').pluck(:name, :pre_words, :suf_words)
    @a_tags = ActsAsTaggableOn::Tag.where(mean: 'a').pluck(:name, :pre_words, :suf_words)

    b = []
    c = []
    i = []
    d = []
    pp = []
    ap = []
    s = []
    o = []
    v = []
    a = []

    @b_tags.each do |t|
       b.push(t[0] +t[1] + t[2])
    end
    @c_tags.each do |t|
       c.push(t[0] +t[1] + t[2])
    end
    @i_tags.each do |t|
       i.push(t[0] +t[1] + t[2])
    end
    @d_tags.each do |t|
       d.push(t[0] +t[1] + t[2])
    end
    @pp_tags.each do |t|
       pp.push(t[0] +t[1] + t[2])
    end
    @ap_tags.each do |t|
       ap.push(t[0] +t[1] + t[2])
    end
    @s_tags.each do |t|
       s.push(t[0] +t[1] + t[2])
    end
    @o_tags.each do |t|
       o.push(t[0] +t[1] + t[2])
    end
    @v_tags.each do |t|
       v.push(t[0] +t[1] + t[2])
    end
    @a_tags.each do |t|
       a.push(t[0] +t[1] + t[2])
    end

    syntax =
    [
      o.sample + b.sample + c.sample + i[0] + 'が' + d[0] + 'に' + s.sample + pp.sample + 'て' + a.sample,
      c.sample + i[0] + 'が' + a.sample + '!' + d[0] + 'に' + s[0] + pp.sample + 'るw最後は' + v.sample + 'でフィニッシュ!',
      i[0] + 'が' + s.sample + ap.sample + 'され' + a.sample + pp.sample + 'て終了' + o.sample,
      s.sample + i[0] + 'がまさかの' + ap.sample + '、' + d.sample + 'に' + pp.sample + 'すぎて' + a.sample,
      d.sample + 'に' + ap.sample + 'される' + c.sample + i[0] + '...' + 'ヤバ過ぎる' + pp.sample + 'で' + a.sample,
      '【' + i[0] + ap.sample + '】' + c.sample + i[0] + 'が' + pp.sample + 'された結果⇒' + v.sample + '&' + a.sample
    ]

    title = syntax.sample
  end
end
