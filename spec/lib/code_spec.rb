require 'code'

describe Code do

  it "parses ruby code" do
    code = "foo = :bar\n"
    Code.parse(code, "ruby").should == %Q|foo = <span class="Constant">:bar</span>|
  end

  it "parses javascript" do
    code = "function() {}();"
    Code.parse(code, "javascript").should == %Q|<span class="Function">function</span>() <span class="Function">{}</span>();|
  end

end
