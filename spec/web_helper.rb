ENV['RACK_ENV'] = 'test'

$:.unshift(File.expand_path('../../web', __FILE__))

require 'application'
require 'rack/test'
require 'nokogiri'

RSpec::Matchers.define :have_link do |expected|

  match do |actual|
    doc = Nokogiri::HTML(actual)
    links = doc.xpath("//a[@href='#{@url}']")
    links.any? { |link| link.inner_text == expected }
  end

  chain :to do |url|
    @url = url
  end

end

RSpec::Matchers.define :have_text do |expected|

  match do |actual|
    doc = Nokogiri::HTML(actual)
    doc.inner_text.include?(expected)
  end

end
