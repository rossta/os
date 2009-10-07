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
  
end
