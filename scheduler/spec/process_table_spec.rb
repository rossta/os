require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::ProcessTable do

  describe "self.load_processes" do
    it "should set instance processes" do
      Scheduling::ProcessTable.load_processes([:p1, :p2])
      Scheduling::ProcessTable.instance.processes.should == [:p1, :p2]
    end
    it "should return processes" do
      Scheduling::ProcessTable.load_processes([:p1, :p2])
      Scheduling::ProcessTable.processes.should == [:p1, :p2]
    end
  end

  describe "terminated?" do
    it "should return false if any processes not terminated" do
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :terminated? => true),
        mock(Scheduling::Process, :terminated? => false)
      ])
      Scheduling::ProcessTable.terminated?.should be_false
    end

    it "should return true if all processes terminated" do
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :terminated? => true),
        mock(Scheduling::Process, :terminated? => true)
      ])
      Scheduling::ProcessTable.terminated?.should be_true
    end
  end

  describe "running_process" do
    it "should return running_process" do
      running = mock(Scheduling::Process, :running? => true)
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :running? => false),
        running
      ])
      Scheduling::ProcessTable.running_process.should == running
    end
    it "should nil if no running process" do
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :running? => false),
        mock(Scheduling::Process, :running? => false)
      ])
      Scheduling::ProcessTable.running_process.should be_nil
    end
  end

  describe "blocked_process" do
    it "should select blocked processes" do
      blocked = mock(Scheduling::Process, :blocked? => true)
      Scheduling::ProcessTable.load_processes([
        blocked,
        mock(Scheduling::Process, :blocked? => false)
      ])
      Scheduling::ProcessTable.blocked_processes.should == [blocked]
    end
    it "should [] if none blocked" do
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :blocked? => false),
        mock(Scheduling::Process, :blocked? => false)
      ])
      Scheduling::ProcessTable.blocked_processes.should == []
    end
  end

  describe "ready_processes" do
    it "should return collection including processes in ready state" do
      Scheduling::Clock.stub!(:time).and_return(0)
      ready_process = mock(Scheduling::Process, :ready? => true)
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :ready? => false, :arrival_time => 100),
        ready_process
      ])
      Scheduling::ProcessTable.ready_processes.should == [ready_process]
    end

    it "should return unstarted processes with current arrival time" do
      Scheduling::Clock.stub!(:time).and_return(3)
      created_process = mock(Scheduling::Process, :ready? => false, :arrival_time => 3)
      Scheduling::ProcessTable.load_processes([
        mock(Scheduling::Process, :ready? => false, :arrival_time => 100),
        created_process
      ])
      Scheduling::ProcessTable.ready_processes.should == [created_process]
    end
  end

  describe "preempt" do
    before(:each) do
      @p1 = Scheduling::Process.new(0,0,0,0)
      @p2 = Scheduling::Process.new(0,0,0,0)
      @p1.state = Scheduling::ProcessState::Running
      @p2.state = Scheduling::ProcessState::Ready
      Scheduling::ProcessTable.load_processes([@p1,@p2])
    end
    it "should transition running process to ready" do
      Scheduling::ProcessTable.preempt
      @p1.ready?.should be_true
    end
    it "should transition stop running process" do
      Scheduling::ProcessTable.preempt
      @p1.running?.should be_false
    end
    it "should return preempted process" do
      Scheduling::ProcessTable.preempt.should == @p1
    end

    it "should throw error if any other running process" do
      @p2.state = Scheduling::ProcessState::Running
      lambda { Scheduling::ProcessTable.preempt }.should raise_error
    end
  end
end
