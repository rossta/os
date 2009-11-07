require File.dirname(__FILE__) + '/../spec_helper'

describe Banker do
  describe "initialize" do
    it "should have tasks" do
      banker = Banker.new([:tasks])
      banker.tasks.should == [:tasks]
    end
  end
  # If the claim is greater than the total number of units in the system the resource manager kills the process when receiving the claim (or returns an error code so that the process can make a new claim).
  # If during the run the process asks for more than its claim, the process is aborted (or an error code is returned and no resources are allocated).
  # If a process claims more than it needs, the result is that the resource manager will be more conservative than need be and there will be more waiting.
  
  describe "safe?" do
    it "should return true if all tasks terminated" do
      tasks = [mock(Task, :terminated? => true), mock(Task, :terminated? => true)]
      banker = Banker.new(tasks)
      banker.safe?.should be_true
    end
    
    describe "one resource type" do
      it "should return true if available resources can satisfy all of a task's max requests" do
        
      end
    
      it "should return false if available resources cannot satisfy all of a task's max requests"
    end
  end
  
  describe "available_resources" do
    it "should return 5 if 3 of 7 are allocated"
  end
end
