require File.dirname(__FILE__) + '/../spec_helper'

describe Banker do
  describe "initialize" do
    it "should have tasks" do
      banker = Banker.new([:tasks], [:resources])
      banker.tasks.should == [:tasks]
    end
    it "should have processes" do
      banker = Banker.new([:tasks], [:resources])
      banker.resources.should == [:resources]
    end
  end
  
  describe "safe?" do
    it "should return true if all tasks terminated" do
      tasks = [mock(Task, :terminated? => true), mock(Task, :terminated? => true)]
      banker = Banker.new(tasks, [:resources])
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
