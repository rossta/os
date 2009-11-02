require File.dirname(__FILE__) + '/spec_helper'

describe Clock do
  describe "start" do
    it "should cycles to 0" do
      Clock.start
      Clock.time.should == 0
      Clock.io_time.should == 0
    end
  end
  
  describe "cycle" do
    it "should increment clock time" do
      Clock.start
      Clock.cycle
      Clock.time.should == 1
    end
  end

  describe "cycle_io" do
    it "should increment io time" do
      Clock.start
      Clock.cycle_io
      Clock.io_time.should == 1
    end
  end
end
