require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Process do
  
  describe "cycle" do
    before(:each) do
      @process = Scheduling::Process.new(0, 0, 0, 0)
    end
    describe "unstarted" do
      it "should switch to ready state" do
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Ready
      end
    end
    
    describe "ready" do
      it "should increment wait time" do
        @process.state = Scheduling::ProcessState::Ready
        @process.cycle
        @process.wait_time.should == 1
      end
      it "should switch to running if cpu burst > 0" do
        @process.state = Scheduling::ProcessState::Ready
        @process.cpu_burst = 2
        Scheduling::ProcessState::Running.should_receive(:cycle).and_return(Scheduling::ProcessState::Running)
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Running
      end
    end
    
    describe "running" do
      it "should decrement cpu burst" do
        @process.state = Scheduling::ProcessState::Running
        @process.cpu_burst = 2
        @process.cycle
        @process.cpu_burst.should == 1
      end
      it "should decrement remaining time" do
        @process.state = Scheduling::ProcessState::Running
        @process.remaining_time = 5
        @process.cycle
        @process.remaining_time.should == 4
      end
      it "should switch to blocked if cpu burst == 0" do
        @process.state = Scheduling::ProcessState::Running
        @process.cpu_burst = 1
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Blocked
      end
      it "should switch to terminated if remaining time == 0" do
        @process.state = Scheduling::ProcessState::Running
        @process.remaining_time = 1
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Terminated
      end
    end
    
    describe "blocked" do
      it "should decrement io burst" do
        @process.state = Scheduling::ProcessState::Blocked
        @process.io_burst = 3
        @process.cycle
        @process.io_burst.should == 2
      end
      it "should increment io time" do
        @process.state = Scheduling::ProcessState::Blocked
        @process.io_time = 4
        @process.cycle
        @process.io_time.should == 5
      end
      it "should switch to ready if io burst == 0" do
        @process.state = Scheduling::ProcessState::Blocked
        @process.io_burst = 1
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Ready
      end
    end
    
    describe "terminated" do
      it "should not switch states" do
        @process.state = Scheduling::ProcessState::Terminated
        @process.cycle
        @process.state.should == Scheduling::ProcessState::Terminated
      end
    end
  end
  describe "initialize" do
    it "should set arrival time = a" do
      Scheduling::Process.new(2, 0, 0, 0).arrival_time.should == 2
    end
    it "should set max cpu burst = b" do
      Scheduling::Process.new(2, 3, 0, 0).max_cpu.should == 3
    end
    it "should set total cpu time = c" do
      Scheduling::Process.new(2, 3, 5, 0).cpu_time.should == 5
    end
    it "should set max io burst = io" do
      Scheduling::Process.new(2, 3, 5, 1).max_io.should == 1
    end
    it "should be unstarted" do
      Scheduling::Process.new(0, 0, 0, 0).state.should == Scheduling::ProcessState::Unstarted
    end
    
  end
  
  describe "to_s" do
    it "should return (a b c io)" do
      Scheduling::Process.new(2, 3, 5, 1).to_s.should == "( 2 3 5 1 )"
    end
  end
  
  describe "turnaround_time" do
    it "should equal finishing time - arrival time" do
      process = Scheduling::Process.new(3,1,5,1)
      process.turnaround_time.should == 5
    end
  end
  
  describe "state_checks" do
    before(:each) do
      @process = Scheduling::Process.new(3,1,5,1)
    end
    describe "running?" do
      it "should return true if in running state" do
        @process.state = Scheduling::ProcessState::Running
        @process.running?.should be_true
      end
      it "should return false if in not running state" do
        @process.state = Scheduling::ProcessState::Ready
        @process.running?.should be_false
      end
    end
    
    describe "blocked?" do
      it "should return true if in blocked state" do
        @process.state = Scheduling::ProcessState::Blocked
        @process.blocked?.should be_true
      end
      it "should return false if in not running state" do
        @process.state = Scheduling::ProcessState::Ready
        @process.blocked?.should be_false
      end
    end

    describe "terminated?" do
      it "should return true if in terminated state" do
        @process.state = Scheduling::ProcessState::Terminated
        @process.terminated?.should be_true
      end
      it "should return false if in not running state" do
        @process.state = Scheduling::ProcessState::Ready
        @process.terminated?.should be_false
      end
    end

    describe "ready?" do
      it "should return true if in terminated state" do
        @process.state = Scheduling::ProcessState::Ready
        @process.ready?.should be_true
      end
      it "should return false if in not running state" do
        @process.state = Scheduling::ProcessState::Terminated
        @process.ready?.should be_false
      end
    end
  end
  
  describe "finishing_time" do
    it "should equal arrival + wait + cpu + io" do
      process = Scheduling::Process.new(3,1,5,1)
      process.wait_time = 2
      process.io_time   = 1
      process.finishing_time.should == (3 + 5 + 2 + 1)
    end
  end
end
