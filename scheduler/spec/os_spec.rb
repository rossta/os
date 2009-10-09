require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::OS do
  describe "random_os" do
    before(:each) do
      RandomNumberGenerator.stub!(:new).and_return(mock(RandomNumberGenerator, :number => 1234))
      @simulator = Scheduling::OS.new
    end
    it "should return 1 + (1234 mod 1)" do
      @simulator.random_os(1).should == 1
    end
    it "should return 1 + (1234 mod 2)" do
      @simulator.random_os(2).should == 1
    end
    it "should return 1 + (1234 mod 3)" do
      @simulator.random_os(3).should == 2
    end
    it "should return 1 + (1234 mod 5)" do
      @simulator.random_os(5).should == 5
    end
  end
  
  describe "terminated?" do
    before(:each) do
      ProcessParser.stub!(:new).and_return(mock(ProcessParser, :parse => nil, :processes => []))
    end
    it "should return false if any processes not terminated" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process, :terminated? => true)
      os.processes << mock(Scheduling::Process, :terminated? => false)
      os.terminated?.should be_false
    end
    
    it "should return true if all processes terminated" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process, :terminated? => true)
      os.processes << mock(Scheduling::Process, :terminated? => true)
      os.terminated?.should be_true
    end
  end
  
  describe "running_process" do
    before(:each) do
      ProcessParser.stub!(:new).and_return(mock(ProcessParser, :parse => nil, :processes => []))
    end
    it "should return process in running state" do
      os = Scheduling::OS.new
      running_process = mock(Scheduling::Process, :running? => true)
      os.processes << mock(Scheduling::Process, :running? => false)
      os.processes << running_process
      os.processes << mock(Scheduling::Process, :running? => false)
      os.running_process.should == running_process
    end
  end
  
  describe "finishing_time" do
    it "should return number of cycles" do
      os = Scheduling::OS.new
      os.cycles = 9
      os.finishing_time.should == 9
    end
  end
  
  describe "cpu_utilization" do
    it "should return floating point total cpu time / finishing time" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process, :cpu_time => 3)
      os.processes << mock(Scheduling::Process, :cpu_time => 5)
      os.cycles = 10
      os.cpu_utilization.should == 0.8
    end
  end

  describe "io_utilization" do
    it "should return floating point total io time / finishing time" do
      os = Scheduling::OS.new
      os.io_cycles = 8
      os.cycles = 10
      os.io_utilization.should == 0.8
    end
  end
  
  describe "throughput" do
    it "should return number of processes * 100 / finishing time" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process)
      os.processes << mock(Scheduling::Process)
      os.cycles = 10
      os.throughput.should == 20.0
    end
  end
  
  describe "turnaround_time" do
    it "should return avg process turnaround time" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process, :turnaround_time => 9)
      os.processes << mock(Scheduling::Process, :turnaround_time => 10)
      os.turnaround_time.should == 9.5
    end
  end
  
  describe "wait_time" do
    it "should return avg process wait time" do
      os = Scheduling::OS.new
      os.processes << mock(Scheduling::Process, :wait_time => 1)
      os.processes << mock(Scheduling::Process, :wait_time => 4)
      os.wait_time.should == 2.5
    end
  end
  
  describe "ready_processes" do
    it "should return collection including processes in ready state" do
      os = Scheduling::OS.new
      ready_process = mock(Scheduling::Process, :ready? => true)
      os.processes << mock(Scheduling::Process, :ready? => false, :arrival_time => 100)
      os.processes << ready_process
      os.ready_processes.should == [ready_process]
    end
    
    it "should return unstarted processes with current arrival time" do
      os = Scheduling::OS.new
      os.cycles = 3
      created_process = mock(Scheduling::Process, :ready? => false, :arrival_time => 3)
      os.processes << mock(Scheduling::Process, :ready? => false, :arrival_time => 100)
      os.processes << created_process
      os.ready_processes.should == [created_process]
    end
  end
end
