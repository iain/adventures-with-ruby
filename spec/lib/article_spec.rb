require 'article'

describe "Article" do

  let(:id) { "article-name" }
  let(:publish) { Date.new(2011, 10, 15) }
  let(:summary) { "The Summary" }
  let(:attributes) { { "title" => "Article Name", "publish" => publish, "summary" => summary } }

  subject { Article.new(id, attributes) }

  it "has an id" do
    subject.id.should == id
  end

  it "has a title" do
    subject.title.should == "Article Name"
  end

  it { should be_found }

  it "can be old" do
    oldness = mock
    oldness.should_receive(:old?).with(publish)
    subject.old?(oldness)
  end

  it "has a summary" do
    subject.summary.should == summary
  end

  it "has a url" do
    subject.url.should == "/article-name"
  end

  it "has contents" do
    contents = mock
    contents.should_receive(:read).with(id)
    subject.contents(contents)
  end

  it "might not be deprecated" do
    subject.should_not be_deprecated
  end

  it "might be deprecated" do
    Article.new(id, attributes.merge("deprecated" => true)).should be_deprecated
  end

end
