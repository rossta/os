require File.dirname(__FILE__) + '/../spec_helper'

describe FifoScheduler do
  before(:each) do
    @scheduler = FifoScheduler.new
  end
  
  describe "schedule" do
    it "should add ready process to queue if not on queue" do
      first = mock(Scheduling::Process, :ready? => true)
      second = mock(Scheduling::Process, :ready? => true)
      @scheduler.queue << first
      @scheduler.schedule(second)
      @scheduler.queue.should == [first, second]
    end
    
    it "should not add ready process to queue if already on queue" do
      first = mock(Scheduling::Process, :ready? => true)
      @scheduler.queue << first
      @scheduler.schedule(first)
      @scheduler.queue.should == [first]
    end
    
    it "should should not add unready process" do
      first = mock(Scheduling::Process, :ready? => false)
      @scheduler.schedule(first)
      @scheduler.queue.should == []
    end
  end
  
  describe "switch?" do
    it "should return true if running_process is nil" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(nil)
      @scheduler.switch?.should be_true
    end
    
    it "should return false if running_process is present" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(:process)
      @scheduler.switch?.should be_false
    end
  end
end