require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::ShortestProcessScheduler do
  describe "next_process" do
    it "should return the process with least remaining time" do
      scheduler       = Scheduling::ShortestProcessScheduler.new
      shortest        = mock(Scheduling::Process, :remaining_time => 2)
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 5)
      scheduler.queue << shortest
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 4)
      
      scheduler.send(:next_process).should == shortest
    end
    it "should return next shorted process next time" do
      scheduler       = Scheduling::ShortestProcessScheduler.new
      next_shortest   = mock(Scheduling::Process, :remaining_time => 3)
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 5)
      scheduler.queue << next_shortest
      scheduler.queue << mock(Scheduling::Process, :remaining_time => 2)
      
      scheduler.send(:next_process)
      scheduler.send(:next_process).should == next_shortest
    end
  end
end
