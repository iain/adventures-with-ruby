require 'application'
require 'rack/test'
require 'nokogiri'

ENV['RACK_ENV'] = 'test'

describe "application" do

  include Rack::Test::Methods
  let(:app) { Sinatra::Application }

  subject { last_response }

  describe "/" do
    before(:all) { get "/" }
    it { should be_ok }
    describe "body" do
      subject { last_response.body }
      it { should have_text("Want more?") }
      it { should have_link("See the rest of the articles").to("/articles") }
    end
  end

  describe "/articles" do
    before(:all) { get "/articles" }
    it { should be_ok }
    describe "body" do
      subject { last_response.body }
      it { should have_link("subscribe to the RSS feed").to("/feed") }
    end
  end

  describe "/:article" do

    let(:name) { "the-name-of-the-article" }

    it "finds the article" do
      Index.should_receive(:find).with(name)
      get "/#{name}"
    end

    pending "renders the article" do
      Index.stub(:find) { double(:found? => true) }
      get "/#{name}"
      should be_ok
    end

  end

  describe "/feed" do
    before { get "/feed" }
    it "renders the RSS feed"
  end

  describe "/stylesheet.css" do
    before(:all) { get "/stylesheet.css" }
    it { should be_ok }
  end

  describe "other paths" do

    before do
      Index.stub(:find) { double(:found? => false) }
      get "/this-url-has-not-been-found"
    end

    it { should_not be_ok }
    it { should be_not_found }
    describe "body" do
      subject { last_response.body }
      it { should have_text("Page Not Found") }
      it { should have_link("list of all articles").to("/articles") }
    end
  end

end


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
