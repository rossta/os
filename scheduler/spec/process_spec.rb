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
    end
    
    describe "running" do
      before(:each) do
        Scheduling::OS.stub!(:random_os).and_return(1)
      end
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
      it "should switch to get io_burst if cpu burst == 0" do
        @process.state = Scheduling::ProcessState::Running
        Scheduling::OS.stub!(:random_os).and_return(3)
        @process.cpu_burst = 1
        @process.cycle
        @process.io_burst.should == 3
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
  
  describe "r_value" do
    describe "arrival_time = 0" do
      it "should return (Clock.time) / running time" do
        Scheduling::Clock.stub!(:time).and_return(10)
        process = Scheduling::Process.new(0, 1, 20, 1)
        process.remaining_time = 15
        expected_r_value = (10.0 / (20.0 - 15.0))
        process.r_value.should == expected_r_value
      end
      it "should return Clock.time if running time is 0" do
        Scheduling::Clock.stub!(:time).and_return(10)
        process = Scheduling::Process.new(0, 1, 20, 1)
        process.r_value.should == 10
      end
    end
    describe "arrival_time > 0" do
      it "should return (Clock.time - arrival_time) / running time" do
        Scheduling::Clock.stub!(:time).and_return(10)
        process = Scheduling::Process.new(5, 1, 20, 1)
        process.remaining_time = 18
        expected_r_value = ((10.0 - 5.0) / (20.0 - 18.0))
        process.r_value.should == expected_r_value
      end
      it "should return (Clock.time - arrival_time) if running time is 0" do
        Scheduling::Clock.stub!(:time).and_return(10)
        process = Scheduling::Process.new(5, 1, 20, 1)
        process.r_value.should == 5
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
  
  describe "<=>" do
    describe "sort based on arrival time" do
      it "should return -1 if arrival time later" do
        process = Scheduling::Process.new(10,0,0,0)
        (process <=> Scheduling::Process.new(0,0,0,0)).should == 1
      end
      
      it "should return +1 if arrival time earlier" do
        process = Scheduling::Process.new(0,0,0,0)
        (process <=> Scheduling::Process.new(10,0,0,0)).should == -1
      end
      
      describe "same arrival time" do
        it "should return -1 if index lower" do
          process = Scheduling::Process.new(10,0,0,0,0)
          (process <=> Scheduling::Process.new(10,0,0,0,10)).should == -1
        end
        it "should return +1 if index higher" do
          process = Scheduling::Process.new(10,0,0,0,10)
          (process <=> Scheduling::Process.new(10,0,0,0,0)).should == 1
        end
      end
    end
  end
  
  describe "process_state" do
    before(:each) do
      @process = Scheduling::Process.new(0, 0, 0, 0)
      @process.io_burst = 3
      @process.cpu_burst = 2
    end

    it "should return blocked and io_burst if blocked" do
      @process.state = Scheduling::ProcessState::Blocked
      @process.current_state.should == "blocked 3"
    end
    it "should return running and cpu_burst if running" do
      @process.state = Scheduling::ProcessState::Running
      @process.current_state.should == "running 2"
    end
    it "should return ready and 0 if ready" do
      @process.state = Scheduling::ProcessState::Ready
      @process.current_state.should == "ready 0"
    end
    it "should return unstarted and 0 if unstarted" do
      @process.state = Scheduling::ProcessState::Unstarted
      @process.current_state.should == "unstarted 0"
    end
    it "should return terminated and 0 if terminated" do
      @process.state = Scheduling::ProcessState::Terminated
      @process.current_state.should == "terminated 0"
    end
  end
end
