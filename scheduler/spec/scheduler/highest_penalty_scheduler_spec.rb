require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::HighestPenaltyScheduler do
  describe "preempt?" do
    it "should return false always" do
      Scheduling::HighestPenaltyScheduler.new.preempt?.should be_false
    end
  end
  
  describe "choose_next" do
    it "should return the process with highest r value" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      highest_r_process = mock(Scheduling::Process, :r_value => 12, :index => 1)
      scheduler.queue << mock(Scheduling::Process, :r_value => 5, :index => 0)
      scheduler.queue << highest_r_process
      scheduler.queue << mock(Scheduling::Process, :r_value => 4, :index => 2)
      
      scheduler.choose_next.should == highest_r_process
    end
    it "should return next highest r value process next time" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      next_highest   = mock(Scheduling::Process, :r_value => 13, :index => 2)
      scheduler.queue << mock(Scheduling::Process, :r_value => 15, :index => 0)
      scheduler.queue << mock(Scheduling::Process, :r_value => 2, :index => 1)
      scheduler.queue << next_highest
      
      scheduler.choose_next
      scheduler.choose_next.should == next_highest
    end
    it "should return oldest matching item if multiple r values" do
      scheduler       = Scheduling::HighestPenaltyScheduler.new
      older           = mock(Scheduling::Process, :r_value => 5, :index => 1)
      scheduler.queue << mock(Scheduling::Process, :r_value => 1)
      scheduler.queue << mock(Scheduling::Process, :r_value => 5, :index => 2)
      scheduler.queue << older
      
      scheduler.choose_next.should == older
    end
  end
  
end
