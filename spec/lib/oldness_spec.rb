require 'oldness'

describe Oldness do

  it "is old when older than 500 days" do
    Oldness.should be_old(Date.today - 500)
  end

  it "is not old when younger than 500 days" do
    Oldness.should_not be_old(Date.today - 499)
  end

end
