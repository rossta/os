require File.dirname(__FILE__) + '/spec_helper'

describe RandomNumberGenerator do
  
  describe "number" do
    it "should return numbers in order from config file" do
      generator = RandomNumberGenerator.new
      generator.number.should == 1804289383
      generator.number.should == 846930886
      generator.number.should == 1681692777
      generator.number.should == 1714636915
    end
  end
end
