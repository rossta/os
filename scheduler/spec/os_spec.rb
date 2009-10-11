require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::OS do
  describe "random_os" do
    before(:each) do
      RandomNumberGenerator.stub!(:number).and_return(1234)
    end
    it "should return 1 + (1234 mod 1)" do
      Scheduling::OS.random_os(1).should == 1
    end
    it "should return 1 + (1234 mod 2)" do
      Scheduling::OS.random_os(2).should == 1
    end
    it "should return 1 + (1234 mod 3)" do
      Scheduling::OS.random_os(3).should == 2
    end
    it "should return 1 + (1234 mod 5)" do
      Scheduling::OS.random_os(5).should == 5
    end
  end

end
