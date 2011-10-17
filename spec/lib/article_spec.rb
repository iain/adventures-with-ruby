require 'article'

describe "Article" do

  let(:id) { "article-name" }
  let(:publish) { Date.new(2011, 10, 15) }
  let(:summary) { "The Summary" }
  let(:attributes) { { "title" => "Article Name", "publish" => publish, "summary" => summary } }

  subject { Article.new(id, attributes) }

  it { should be_found }

  it "has an id" do
    subject.id.should == id
  end

  describe "#title" do

    it "is read from the attributes" do
      subject.title.should == "Article Name"
    end

  end

  describe "#summary" do

    it "is read from the attributes" do
      subject.summary.should == summary
    end

  end

  describe "#published_at" do

    it "is read from the publish attribute" do
      subject.published_at.should == publish
    end

  end

  describe "#url" do

    it "is made from the id" do
      subject.url.should == "/article-name"
    end

  end

  describe "#deprecated?" do

    it "might not be deprecated" do
      subject.should_not be_deprecated
    end

    it "might be deprecated" do
      subject = Article.new(id, "deprecated" => true)
      subject.should be_deprecated
    end

  end

  describe "#disqus_id" do

    let(:wp) { 123 }
    let(:disqus) { double }

    it "delegates to Disqus with wordpress id" do
      subject = Article.new(id, "wp" => wp)
      disqus.should_receive(:id).with(id, wp)
      subject.disqus_id(disqus)
    end

    it "delegates to Disqus when there is no wordpress id" do
      disqus.should_receive(:id).with(id, nil)
      subject.disqus_id(disqus)
    end

  end

  describe "#old?" do

    let(:oldness) { double }
    let(:deprecated) { double }

    before { subject.stub(:deprecated?).and_return(deprecated) }

    it "delegates to oldness class with deprecated" do
      oldness.should_receive(:old?).with(publish, deprecated)
      subject.old?(oldness)
    end

  end

  describe "#contents" do

    it "delegates to Contents class" do
      contents = mock
      contents.should_receive(:new).with(id)
      subject.contents(contents)
    end

    it "caches contents" do
      contents = mock
      contents.should_receive(:new).with(id).once.and_return(double)
      2.times { subject.contents(contents) }
    end

  end

end
