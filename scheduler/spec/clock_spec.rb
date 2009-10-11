require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Clock do
  describe "start" do
    it "should cycles to 0" do
      Scheduling::Clock.start
      Scheduling::Clock.time.should == 0
      Scheduling::Clock.io_time.should == 0
    end
  end
  
  describe "cycle" do
    it "should increment clock time" do
      Scheduling::Clock.start
      Scheduling::Clock.cycle
      Scheduling::Clock.time.should == 1
    end
  end

  describe "cycle_io" do
    it "should increment io time" do
      Scheduling::Clock.start
      Scheduling::Clock.cycle_io
      Scheduling::Clock.io_time.should == 1
    end
  end
end
