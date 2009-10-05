require File.dirname(__FILE__) + '/spec_helper'

describe OSSimulator do
  describe "random_os" do
    it "should return 1 + (1234 mod 1)" do
      simulator = OSSimulator.new
      RandomNumberGenerator.stub!(:new).and_return(mock(RandomNumberGenerator, :number => 1234))
      simulator.random_os(1).should == 1
    end
    it "should return 1 + (1234 mod 2)" do
      simulator = OSSimulator.new
      RandomNumberGenerator.stub!(:new).and_return(mock(RandomNumberGenerator, :number => 1234))
      simulator.random_os(2).should == 1
    end
    it "should return 1 + (1234 mod 3)" do
      simulator = OSSimulator.new
      RandomNumberGenerator.stub!(:new).and_return(mock(RandomNumberGenerator, :number => 1234))
      simulator.random_os(3).should == 2
    end
    it "should return 1 + (1234 mod 5)" do
      simulator = OSSimulator.new
      RandomNumberGenerator.stub!(:new).and_return(mock(RandomNumberGenerator, :number => 1234))
      simulator.random_os(5).should == 5
    end
  end
end
