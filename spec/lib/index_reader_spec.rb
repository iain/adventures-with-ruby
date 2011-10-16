require 'index_reader'

describe IndexReader do

  describe ".read" do
    it "delegates to instance read with default file" do
      reader = double
      filename = double
      IndexReader.should_receive(:new).with(filename).and_return(reader)
      reader.should_receive(:read)
      IndexReader.read(filename)
    end
  end

  describe "#read" do
    it "reads the file"
  end

end
