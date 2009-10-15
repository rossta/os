require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::ShortestRemainingScheduler do
  describe "preempt?" do
    before(:each) do
      @scheduler = Scheduling::ShortestRemainingScheduler.new
    end
    it "should be false if running process nil" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(nil)
      @scheduler.preempt?.should be_false
    end
    
    it "should be true if least ready remaining time less than running remaining time" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(mock(Scheduling::Process, :remaining_time => 10))
      @scheduler.queue << mock(Scheduling::Process, :remaining_time => 15)
      @scheduler.queue << mock(Scheduling::Process, :remaining_time => 4)
      @scheduler.preempt?.should be_true
    end
    
    it "should be false if running process has least remaining time" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(mock(Scheduling::Process, :remaining_time => 1))
      @scheduler.queue << mock(Scheduling::Process, :remaining_time => 15)
      @scheduler.queue << mock(Scheduling::Process, :remaining_time => 4)
      @scheduler.preempt?.should be_false
    end

    it "should be false if queue empty" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(mock(Scheduling::Process, :remaining_time => 1))
      @scheduler.queue = []
      @scheduler.preempt?.should be_false
    end
  end
  describe "choose_next" do
    it "should return the process with least remaining time" do
      scheduler       = Scheduling::ShortestRemainingScheduler.new
      shortest        = mock(Scheduling::Process, :remaining_time => 2)
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 5)
      scheduler.queue << shortest
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 4)
      
      scheduler.choose_next.should == shortest
    end
    it "should return next shorted process next time" do
      scheduler       = Scheduling::ShortestRemainingScheduler.new
      next_shortest   = mock(Scheduling::Process, :remaining_time => 3)
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 5)
      scheduler.queue << next_shortest
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 2)
      
      scheduler.choose_next
      scheduler.choose_next.should == next_shortest
    end
  end
end
