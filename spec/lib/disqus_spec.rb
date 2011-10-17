require 'disqus'

describe Disqus do

  describe ".id" do

    it "returns id if wordpress id is nil" do
      Disqus.id("id", nil).should == "id"
    end

    it "returns the old wordpress url if wordpress id is present" do
      Disqus.id("id", 123).should == "123 http://iain.nl/?p=123"
    end

  end

end
