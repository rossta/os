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
      it "should return false if cycle < q" do
        @scheduler.switch?.should be_false
      end
      
      it "should return true if cycle == q" do
        @scheduler.cycle = 2
        @scheduler.switch?.should be_true
      end
    end
  end
  
  describe "before_next_process" do
    it "should decrement cycle if cycle > 0" do
      @scheduler.cycle = 2
      @scheduler.before_next_process
      @scheduler.cycle.should == 1
    end
    
    it "should reset cycle to quantum if cycle = 0" do
      @scheduler.cycle = 0
      @scheduler.before_next_process
      @scheduler.cycle.should == RoundRobinScheduler::QUANTUM
    end
  end
end
