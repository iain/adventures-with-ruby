require 'index'

describe Index do

  let(:found) { double(:found? => true) }
  let(:not_found) { double(:found? => false) }

  describe  "#find" do

    subject { Index.new({"existing-article" => found}, nil, not_found) }

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
      index_reader = double
      index_reader.should_receive(:read).and_return(reader)
      Index.new(nil, index_reader, not_found).find("something")
    end

  end

end
