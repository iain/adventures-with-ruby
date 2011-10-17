require 'contents'

describe Contents do

  let(:source) { double("ContentsFile#new", :read => {}) }
  let(:source_class) { double("ContentsFile", :new => source) }
  subject { Contents.new("compiled-article", source_class) }

  describe "#html" do

    it "reads html from the compiled file" do
      html = "Compiled HTML"
      source.should_receive(:read).and_return("html" => html)
      subject.html.should == html
    end

  end

  describe "#toc" do

    it "reads table of contents from the compiled file" do
      toc = [ { "anchor" => "#html+anchor", "title" => "HTML title" } ]
      source.should_receive(:read).and_return("toc" => toc)
      subject.toc.should == toc
    end

  end

  describe "#introduction" do

    it "reads the introduction from the compiled file" do
      introduction = "Compiled introduction"
      source.should_receive(:read).and_return("introduction" => introduction)
      subject.introduction.should == introduction
    end

  end

  describe "#toc?" do

    it "returns true if there are more than 2 items in the table of contents" do
      subject.should_receive(:toc).and_return([1, 2, 3])
      subject.toc?.should == true
    end

    it "returns false if there are 2 items or less" do
      subject.should_receive(:toc).and_return([1,2])
      subject.toc?.should == false
    end

  end

end
