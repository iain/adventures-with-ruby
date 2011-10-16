require 'contents'

describe Contents do

  let(:path) { "spec" }

  subject { Contents.new("compiled-article", path) }

  describe "#html" do

    it "reads html from the compiled file" do
      subject.html.should == "Compiled HTML"
    end

  end

  describe "#toc" do

    it "reads table of contents from the compiled file" do
      subject.toc.should == [ { "anchor" => "#html+anchor", "title" => "HTML title" } ]
    end

  end

  describe "#introduction" do

    it "reads the introduction from the compiled file" do
      subject.introduction.should == "Compiled introduction"
    end

  end

  describe "#toc?" do

  end

end
