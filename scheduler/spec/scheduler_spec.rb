require File.dirname(__FILE__) + '/spec_helper'

describe Scheduler do
  before(:each) do
    @scheduler = Scheduler.new
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
end
