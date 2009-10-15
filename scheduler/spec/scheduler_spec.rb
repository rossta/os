require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Scheduler do
  before(:each) do
    @scheduler = Scheduling::Scheduler.new
  end
  describe "switch?" do
    it "should return true if running process is nil" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(nil)
      @scheduler.switch?.should be_true
    end
    
    it "should return false running_process not nil" do
      Scheduling::ProcessTable.stub!(:running_process).and_return(:process)
      @scheduler.switch?.should be_false
    end
  end
  
  describe "add_to_queue" do
    it "should add ready process to queue if not on queue" do
      first = mock(Scheduling::Process, :ready? => true)
      second = mock(Scheduling::Process, :ready? => true)
      @scheduler.queue << first
      @scheduler.send(:add_to_queue,second)
      @scheduler.queue.should == [first, second]
    end
    
    it "should not add ready process to queue if already on queue" do
      first = mock(Scheduling::Process, :ready? => true)
      @scheduler.queue << first
      @scheduler.send(:add_to_queue,first)
      @scheduler.queue.should == [first]
    end
    
    it "should should not add unready process" do
      first = mock(Scheduling::Process, :ready? => false)
      @scheduler.send(:add_to_queue,first)
      @scheduler.queue.should == []
    end
  end
  
end
