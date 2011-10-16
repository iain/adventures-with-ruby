require 'article'

describe "Article" do

  it "allows for attributes" do
    attributes = { "title" => "Article Name", "publish" => Date.new(2011, 10, 15), "summary" => "Summary" }
    article = Article.new(attributes)
    article.title.should == "Article Name"
  end

end
