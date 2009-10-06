require File.dirname(__FILE__) + '/spec_helper'

describe Scheduler do
  describe "to_s" do
  end
  
  
  describe "terminated?" do
    before(:each) do
      ProcessParser.stub!(:new).and_return(mock(ProcessParser, :parse => nil, :processes => []))
    end
    it "should return false if any processes not terminated" do
      scheduler = Scheduler.new("/foo")
      scheduler.processes << mock(Scheduling::Process, :terminated? => true)
      scheduler.processes << mock(Scheduling::Process, :terminated? => false)
      scheduler.terminated?.should be_false
    end
    
    it "should return true if all processes terminated" do
      scheduler = Scheduler.new("/foo")
      scheduler.processes << mock(Scheduling::Process, :terminated? => true)
      scheduler.processes << mock(Scheduling::Process, :terminated? => true)
      scheduler.terminated?.should be_true
    end
  end
  
  describe "running_process" do
    before(:each) do
      ProcessParser.stub!(:new).and_return(mock(ProcessParser, :parse => nil, :processes => []))
    end
    it "should return process in running state" do
      scheduler = Scheduler.new("/foo")
      running_process = mock(Scheduling::Process, :running? => true)
      scheduler.processes << mock(Scheduling::Process, :running? => false)
      scheduler.processes << running_process
      scheduler.processes << mock(Scheduling::Process, :running? => false)
      scheduler.running_process.should == running_process
    end
  end
  
  describe "FIFO: next_ready_process" do
    before(:each) do
      ProcessParser.stub!(:new).and_return(mock(ProcessParser, :parse => nil, :processes => []))
      @scheduler = Scheduler.new("/foo")
    end

    it "should return first if no running process" do
      pending
      first = mock(Scheduling::Process,   :running? => false, :terminated? => false)
      second = mock(Scheduling::Process,  :running? => false, :terminated? => false)
      @scheduler.processes << first
      @scheduler.processes << second
      @scheduler.next_ready_process.should == first
    end

    it "should return second if running process is first" do
      pending
      first = mock(Scheduling::Process,   :running? => true,  :terminated? => false)
      second = mock(Scheduling::Process,  :running? => false, :terminated? => false)
      @scheduler.processes << first
      @scheduler.processes << second
      @scheduler.next_ready_process.should == second
    end

    it "should return first if running process is last" do
      pending
      first = mock(Scheduling::Process,   :running? => false,   :terminated? => false)
      last = mock(Scheduling::Process,    :running? => true,    :terminated? => false)
      @scheduler.processes << first
      @scheduler.processes << second
      @scheduler.next_ready_process.should == second
    end

    it "should return next if first process is terminated" do
      pending
      first = mock(Scheduling::Process,   :running? => true,  :terminated? => false)
      second = mock(Scheduling::Process,  :running? => false, :terminated? => false)
      @scheduler.processes << first
      @scheduler.processes << second
      @scheduler.next_ready_process.should == second
    end

    it "should return nil if all running processes terminated" do
      pending
      first = mock(Scheduling::Process,   :running? => true,  :terminated? => false)
      second = mock(Scheduling::Process,  :running? => false, :terminated? => false)
      @scheduler.processes << first
      @scheduler.processes << second
      @scheduler.next_ready_process.should == second
    end
  end
end
