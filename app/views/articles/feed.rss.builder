xml.instruct! :xml, :version => "1.0"
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
 xml.channel do
   xml.title 'Nampa Picks [ナンパピックス]'
   xml.description 'ナンパ専門のエロ動画キュレーション、【Nampa Picks】。素人ナンパのエロ動画のまとめアンテナサイトです。ログイン不要のお気に入り機能で、お好きな動画をコレクションできます。'
   xml.link 'http://nampa-picks.net'
   @articles.each do |a|
     xml.item do
       xml.title a.title
       xml.description a.description
       xml.pubDate a.created_at
       xml.guid "http://nampa-picks.net/articles/#{a.id}"
       xml.link "http://nampa-picks.net/articles/#{a.id}"
     end
   end
 end
end
