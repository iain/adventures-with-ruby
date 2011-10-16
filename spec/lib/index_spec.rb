require 'index'

describe Index do

  it "cannot find some random article" do
    Index.find("name-of-the-article").should_not be_found
  end

  pending "can find existing article" do
    Index.find("existing-article").should be_found
  end

end
