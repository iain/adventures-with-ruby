xml.instruct!
xml.feed xmlns: "http://www.w3.org/2005/Atom" do
  xml.title "Adventures with Ruby"
  xml.subtitle "Article feed of Adventures with Ruby"
  xml.link href: "http://adventures-with-ruby.com"
  xml.updated CGI.rfc1123_date(@archive.first.published_at.to_time)
  xml.author do
    xml.name "Iain Hecker"
    xml.email "iain@iain.nl"
  end
  @archive.each do |article|
    xml.entry do
      xml.title   article.title
      xml.link    href: "http://adventures-with-ruby.com#{article.url}"
      xml.updated CGI.rfc1123_date(article.published_at.to_time)
      xml.summary "#{article.introduction_without_html} [...]"
      xml.id      "http://adventures-with-ruby.com#{article.url}"
    end
  end
end
