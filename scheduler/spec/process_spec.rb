require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Process do
  describe "initialize" do
    it "should set arrival time = a" do
      Scheduling::Process.new(2, 0, 0, 0).arrival_time.should == 2
    end
    it "should set max cpu burst = b" do
      Scheduling::Process.new(2, 3, 0, 0).cpu_burst.should == 3
    end
    it "should set total cpu time = c" do
      Scheduling::Process.new(2, 3, 5, 0).cpu_time.should == 5
    end
    it "should set max io burst = io" do
      Scheduling::Process.new(2, 3, 5, 1).io_burst.should == 1
    end
  end
  
  describe "to_s" do
    it "should return (a b c io)" do
      Scheduling::Process.new(2, 3, 5, 1).to_s.should == "(2 3 5 1)"
    end
  end
end
