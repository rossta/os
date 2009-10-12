require File.dirname(__FILE__) + '/../spec_helper'

describe RoundRobinScheduler do
  before(:each) do
    @scheduler = RoundRobinScheduler.new
  end
  describe "switch?" do
    it "should return true if running process is nil" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(nil)
      @scheduler.switch?.should be_true
    end
    
    describe "running_process" do
      before(:each) do
        Scheduling::ProcessTable.stub!(:running_process).and_return(:process)
      end
      it "should return false if cycle > 0" do
        @scheduler.cycle = 1
        @scheduler.switch?.should be_false
      end
      
      it "should return true if cycle == 0" do
        @scheduler.switch?.should be_true
      end
    end
  end
  
  describe "run_cycle" do
    it "should decrement cycle if cycle > 0" do
      @scheduler.cycle = 2
      @scheduler.run_cycle
      @scheduler.cycle.should == 1
    end
    
    it "should reset cycle to quantum if cycle = 0" do
      @scheduler.cycle = 0
      @scheduler.run_cycle
      @scheduler.cycle.should == RoundRobinScheduler::QUANTUM
    end
  end
end
