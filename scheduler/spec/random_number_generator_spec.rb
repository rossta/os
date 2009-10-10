require File.dirname(__FILE__) + '/spec_helper'

describe RandomNumberGenerator do
  before(:each) do
    RandomNumberGenerator.clear!
  end
  describe "self.number" do
    it "should return numbers in order from config file" do
      RandomNumberGenerator.number.should == 1804289383
      RandomNumberGenerator.number.should == 846930886
      RandomNumberGenerator.number.should == 1681692777
      RandomNumberGenerator.number.should == 1714636915
    end
  end
  
  describe "self.clear!" do
    it "should description" do
      RandomNumberGenerator.number.should == 1804289383
      RandomNumberGenerator.number.should == 846930886
      RandomNumberGenerator.clear!
      RandomNumberGenerator.number.should == 1804289383
    end
  end
end
