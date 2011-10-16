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
    it "reads the file"
  end

end
