require File.dirname(__FILE__) + '/spec_helper'

describe RandomNumberGenerator do
  before(:each) do
    scheduler_random_numbers_file = File.dirname(__FILE__) + '/../config/scheduler/random_numbers'
    Configuration.stub!(:random_numbers_file).and_return(scheduler_random_numbers_file)
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
