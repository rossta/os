require File.dirname(__FILE__) + '/spec_helper'

describe Scheduler do
  describe "running_process" do
    it "should return process in running state" do
      pending
      running_process = mock(Scheduling::Process, :running? => true)
      os.processes << mock(Scheduling::Process, :running? => false)
      os.processes << running_process
      os.processes << mock(Scheduling::Process, :running? => false)
      os.running_process.should == running_process
    end
  end
  
end
