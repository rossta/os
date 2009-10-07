require File.dirname(__FILE__) + '/../spec_helper'

describe FifoScheduler do
  before(:each) do
    @scheduler = FifoScheduler.new
  end
  
  describe "next_ready_process" do

    it "should return first if no running process" do
      first = mock(Scheduling::Process)
      second = mock(Scheduling::Process)
      @scheduler.queue << first
      @scheduler.queue << second
      @scheduler.next_ready_process.should == first
    end

    it "should return nil if queue empty" do
      @scheduler.next_ready_process.should be_nil
    end
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
  
  describe "to_s" do
    describe "input_1" do
      it "should match output_1" do
        pending
        scheduler = FifoScheduler.new(FIXTURES + "input_1.txt")
        scheduler.run
        scheduler.to_s.should == File.open(FIXTURES + "fifo/output_1.txt").read
      end
    end
  end
end