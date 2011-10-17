require 'oldness'

describe Oldness do

  context "when older than 500 days" do

    let(:date) { Date.today - 500 }

    it "is old when not deprecated" do
      Oldness.should be_old(date, false)
    end

    it "is not old when deprecated" do
      Oldness.should_not be_old(date, true)
    end

  end

  context "when younger than 500 days" do

    let(:date) { Date.today - 499 }

    it "is not old when not deprecated" do
      Oldness.should_not be_old(date, false)
    end

    it "is not old when deprecated" do
      Oldness.should_not be_old(date, true)
    end

  end

end
