require 'code'

describe Code do

  let(:out) { double("out").as_null_object }

  it "parses ruby code" do
    code = "foo = :bar\n"
    Code.parse(code, "ruby", out).should == %Q|foo = <span class="Constant">:bar</span>|
  end

  it "parses javascript" do
    code = "function() {}();"
    Code.parse(code, "javascript", out).should == %Q|<span class="Function">function</span>() <span class="Function">{}</span>();|
  end

end
