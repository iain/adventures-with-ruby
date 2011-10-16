require 'contents'

describe Contents do

  describe ".read" do

    it "delegates to an instance" do
      id = double
      contents = double
      Contents.should_receive(:new).with(id).and_return(contents)
      contents.should_receive(:read)
      Contents.read(id)
    end

    it "caches contents based on id" do
      id = double("id")
      other_id = double("other-id")
      Contents.should_receive(:new).with(id).once.and_return(stub.as_null_object)
      Contents.should_receive(:new).with(other_id).once.and_return(stub.as_null_object)
      5.times { Contents.read(id) }
      3.times { Contents.read(other_id) }
    end

  end

end
