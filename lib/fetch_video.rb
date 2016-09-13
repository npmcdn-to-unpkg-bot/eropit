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
      a.title = generate_title(morphological_analysis(video[:title]))
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

  def morphological_analysis(title)
    YahooParseApi::Config.app_id = 'dj0zaiZpPWxhUlVicWFhVDd2ayZzPWNvbnN1bWVyc2VjcmV0Jng9YmM-'
    result = YahooParseApi::Parse.new.parse(title, {
      results: 'ma'
    })
    tags = []
    words = result['ResultSet']['ma_result']['word_list']['word']
    words.each do |word|
      tags << word['surface'] if word['surface'].length > 1
    end
    save_tags(tags)

    tags
  end

  def save_tags(tags)
    tags.each do |tag|
      ActsAsTaggableOn::Tag.create(name: tag) unless ActsAsTaggableOn::Tag.exists?(name: tag)
    end
  end

  def generate_title(tags)

    puts tags

    final_tags = []

    flags = {
      'b' => false,
      'c' => false,
      'i' => false,
      'd' => false,
      'pp' => false,
      'ap' => false,
      's' => false,
      'o' => false,
      'v' => false,
      'a' => false
    }

    tags.each do |tag|
      next if final_tags.exists?(name: tag)

      t = ActsAsTaggableOn::Tag.where(name: tag).limit(1)
      next if flags[t.mean] == true
      flags[t.mean] = true
      final_tags << t
    end

    flags.each do |mean, flag|
      next if flag == true
      t = ActsAsTaggableOn::Tag.where(name: tag).limit(1)
      final_tags << t
    end

    b_ = final_tags.where(mean: 'b')
    c_ = final_tags.where(mean: 'c')
    i_ = final_tags.where(mean: 'i')
    d_ = final_tags.where(mean: 'd')
    pp_ = final_tags.where(mean: 'pp')
    ap_ = final_tags.where(mean: 'ap')
    s_ = final_tags.where(mean: 's')
    o_ = final_tags.where(mean: 'o')
    v_ = final_tags.where(mean: 'v')
    a_ = final_tags.where(mean: 'a')

    b = b_.pre_words + b_.name + b_.suf_words
    c = c_.pre_words + c_.name + c_.suf_words
    i = i_.pre_words + i_.name + i_.suf_words
    d = d_.pre_words + d_.name + d_.suf_words
    pp = pp_.pre_words + pp_.name + pp_.suf_words
    ap = ap_.pre_words + ap_.name + ap_.suf_words
    s = s_.pre_words + s_.name + s_.suf_words
    o = o_.pre_words + o_.name + o_.suf_words
    v = v_.pre_words + v_.name + v_.suf_words
    a = a_.pre_words + a_.name + a_.suf_words

    syntax =
    [
      o + b + c + i + 'が' + d + 'に' + s + pp + 'て' + a,
      c + i + 'が' + a + '!' + d + 'に' + s + pp + 'るw最後は' + v + 'でフィニッシュ!',
      i + 'が' + s + ap + 'され' + a + pp + 'て終了' + o,
      s + i + 'がまさかの' + ap + '、' + d + 'に' + pp + 'すぎて' + a,
      d + 'に' + ap + 'される' + c + i + '...' + 'ヤバ過ぎる' + pp + 'で' + a,
      '【' + i + ap + '】' + c + i + 'が' + pp + 'された結果⇒' + v + '&' + a
    ]

    title = syntax.sample
  end
end
