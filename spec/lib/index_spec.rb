require 'index'

describe Index do

  let(:article) { double(:found? => true) }

  describe  "#find" do

    subject { Index.new("existing-article" => article) }

    it "cannot find some random article" do
      subject.find("name-of-the-article").should_not be_found
    end

    it "can find existing article" do
      subject.find("existing-article").should be_found
    end

  end

  describe ".find" do

    it "delegates to instance find" do
      index = double
      Index.should_receive(:new).and_return(index)
      index.should_receive(:find).with("stuff")
      Index.find("stuff")
    end

  end

  context "when there is no index" do

    it "will get it from the list" do
      reader = double(:fetch => true)
      IndexReader.should_receive(:read).and_return(reader)
      Index.new.find("something")
    end

  end

end
