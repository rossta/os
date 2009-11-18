require File.dirname(__FILE__) + '/spec_helper'

describe RandomNumberGenerator do
  before(:each) do
    Configuration.random_numbers_file = Configuration::DUMMY_RANDOM_NUMBERS_FILE
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

  describe "self.quotient" do
    it "should return random_number / DENOMINATOR" do
      number      = 1804289383
      denominator = 2147483648.to_f
      RandomNumberGenerator.quotient.should == (number / denominator)
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
