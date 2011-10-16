require 'article'

describe Article do

  it "cannot find some random article" do
    Article.find("name-of-the-article").should_not be_found
  end

  pending "can find existing article" do
    Article.find("existing-article").should be_found
  end

end
