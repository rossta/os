require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::HighestPenaltyScheduler do
  describe "preempt?" do
    it "should return false always" do
      Scheduling::HighestPenaltyScheduler.new.preempt?.should be_false
    end
  end
  
  describe "next_process" do
    it "should return the process with highest r value" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      highest_r_process = mock(Scheduling::Process, :r_value => 12)
      scheduler.queue << mock(Scheduling::Process, :r_value => 5)
      scheduler.queue << highest_r_process
      scheduler.queue << mock(Scheduling::Process, :r_value => 4)
      
      scheduler.next_process.should == highest_r_process
    end
    it "should return next highest r value process next time" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      next_highest   = mock(Scheduling::Process, :r_value => 13)
      scheduler.queue << mock(Scheduling::Process, :r_value => 15)
      scheduler.queue << mock(Scheduling::Process, :r_value => 2)
      scheduler.queue << next_highest
      
      scheduler.next_process
      scheduler.next_process.should == next_highest
    end
    it "should return oldest matching item if multiple r values" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      older           = mock(Scheduling::Process, :r_value => 5)
      scheduler.queue << mock(Scheduling::Process, :r_value => 1)
      scheduler.queue << older
      scheduler.queue << mock(Scheduling::Process, :r_value => 5)
      
      scheduler.next_process.should == older
    end
  end
  
end
