require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::RoundRobinScheduler do
  before(:each) do
    @scheduler = Scheduling::RoundRobinScheduler.new
  end
  
  describe "schedule_processes" do
    it "should increment quantum" do
      @scheduler.schedule_processes
      @scheduler.quantum.should == 1
    end
    describe "quantum is full" do
      it "should preempt running process" do
        @scheduler.quantum == 2
        Scheduling::ProcessTable.should_receive(:preempt)
        @scheduler.schedule_processes
      end
      it "should reset quantum and increment" do
        @scheduler.quantum == 2
        @scheduler.schedule_processes
        @scheduler.quantum.should == 1
      end
    end
  end
end
