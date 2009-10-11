require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::OS do
  describe "random_os" do
    before(:each) do
      RandomNumberGenerator.stub!(:number).and_return(1234)
    end
    it "should return 1 + (1234 mod 1)" do
      Scheduling::OS.random_os(1).should == 1
    end
    it "should return 1 + (1234 mod 2)" do
      Scheduling::OS.random_os(2).should == 1
    end
    it "should return 1 + (1234 mod 3)" do
      Scheduling::OS.random_os(3).should == 2
    end
    it "should return 1 + (1234 mod 5)" do
      Scheduling::OS.random_os(5).should == 5
    end
  end

  describe "cpu_utilization" do
    it "should return floating point total cpu time / finishing time" do
      os = Scheduling::OS.new
      Scheduling::ProcessTable.stub!(:processes).and_return([
        mock(Scheduling::Process, :cpu_time => 3),
        mock(Scheduling::Process, :cpu_time => 5)
      ])
      Scheduling::Clock.stub!(:time).and_return(10)
      os.cpu_utilization.should == 0.8
    end
  end

  describe "io_utilization" do
    it "should return floating point total io time / finishing time" do
      os = Scheduling::OS.new
      Scheduling::Clock.stub!(:io_time).and_return(8)
      Scheduling::Clock.stub!(:time).and_return(10)
      os.io_utilization.should == 0.8
    end
  end

  describe "throughput" do
    it "should return number of processes * 100 / finishing time" do
      os = Scheduling::OS.new
      Scheduling::ProcessTable.stub!(:processes).and_return([
        mock(Scheduling::Process),
        mock(Scheduling::Process)
      ])
      Scheduling::Clock.stub!(:time).and_return(10)
      os.throughput.should == 20.0
    end
  end

  describe "turnaround_time" do
    it "should return avg process turnaround time" do
      os = Scheduling::OS.new
      Scheduling::ProcessTable.stub!(:processes).and_return([
        mock(Scheduling::Process, :turnaround_time => 9),
        mock(Scheduling::Process, :turnaround_time => 10)
      ])
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

end
