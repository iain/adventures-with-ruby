require 'index_reader'

describe IndexReader do

  describe ".read" do

    it "delegates to instance read with default file" do
      reader = double
      filename = "articles/_index.yml"
      IndexReader.should_receive(:new).with(filename).and_return(reader)
      reader.should_receive(:read)
      IndexReader.read
    end

  end

  describe "#read" do

    let(:article_class) { double("ArticleClass") }

    subject { IndexReader.new("spec/index.yml", article_class) }

    it "makes an article instance" do
      article = { "title" => "Article Name", "publish" => Date.new(2011, 10, 15), "summary" => "Summary" }
      article_class.should_receive(:new).with(article)
      subject.read
    end

    it "reads the file" do
      article = double("article")
      article_class.stub(:new) { article }
      subject.read.should == { "article-name" => article }
    end
  end

end
