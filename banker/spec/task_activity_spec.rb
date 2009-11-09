require File.dirname(__FILE__) + '/spec_helper'

describe TaskActivity do
  describe "name" do
    it "should return initiate for TaskActivity::Initiate" do
      TaskActivity::Initiate.new(mock(Task, :number => 1), 0,0).name.should == "initiate"
    end
    it "should return terminate for TaskActivity::Terminate" do
      TaskActivity::Terminate.new(mock(Task, :number => 1)).name.should == "terminate"
    end
  end

  describe "Base" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Base.new(mock(Task, :number => 1),1,2)
      end
      it "should mark as processed" do
        @activity.process
        @activity.processed?.should be_true
      end
    end
  end
  
  describe "Initiate" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Initiate.new(mock(Task),1,2)
      end
    end
  end
  
  describe "Terminate" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Terminate.new(mock(Task, :number => 1),1,2)
      end
      
      it "should mark processed" do
        @activity.process
        @activity.processed?.should be_true
      end
    end
  end
  describe "Request" do
    before(:each) do
      @resource = mock(Resource, :resource_type => 1, :request => 2, :units => 3, :replenish => nil)
      ResourceTable.stub!(:find).and_return(@resource)
      @task = mock(Task, :allocate => {}, :allocation => {}, :number => 1)
      @activity = TaskActivity::Request.new(@task,1,2)
    end
    describe "process" do
      it "should request units" do
        @resource.should_receive(:request).with(2).exactly(1).times
        @activity.process
      end
      it "should mark processed" do
        @activity.process
        @activity.processed?.should be_true
      end
      it "should allocate units to task" do
        @task.should_receive(:allocate).with(1, 2).exactly(1).times
        @activity.process
      end
    end
    describe "greedy?" do
      before(:each) do
        @task.stub!(:initial_claim_for).with(1).and_return(2)
      end
      it "should return false if allocation nil and current request <= task initial claim" do
        @activity.greedy?.should be_false
      end
      it "should return false if allocation + current request <= task initial claim" do
        @task.allocation[1] = 0
        @task.should_receive(:initial_claim_for).with(1).and_return(2)
        @activity.greedy?.should be_false
      end
      it "should return true if allocation + current request > initial claim" do
        @task.allocation[1] = 2
        @task.should_receive(:initial_claim_for).with(1).and_return(2)
        @activity.greedy?.should be_true
      end
    end
  end
  describe "Release" do
    before(:each) do
      @resource = mock(Resource, :resource_type => 1, :units => 4)
      ResourceTable.stub!(:find).and_return(@resource)
      ResourceTable.stub!(:replenish)
      @task = mock(Task, :release => 3, :number => 1)
      @activity = TaskActivity::Release.new(@task,1,3)
    end
    
    describe "process" do
      it "should request units" do
        ResourceTable.should_receive(:replenish).with(3).exactly(1).times
        @activity.process
      end
      it "should mark processed" do
        @activity.process
        @activity.processed?.should be_true
      end
      it "should allocate units to task" do
        @task.should_receive(:release).with(1, 3).exactly(1).times
        @activity.process
      end
    end
  end
  describe "Compute" do
    before(:each) do
      @task = mock(Task, :number => 1)
      @activity = TaskActivity::Compute.new(@task, 2)
    end
    it "should have total cycles" do
      @activity.total_cycles.should == 2
    end
    it "should have 0 processed cycles" do
      @activity.processed_cycles.should == 0
    end
    describe "process" do
      it "should increment cycle counter" do
        @activity.process
        @activity.processed_cycles.should == 1
      end
      it "should not be processed if remaining cycles" do
        @activity.process
        @activity.processed?.should be_false
      end
      it "should be processed if remaining cycles" do
        @activity.process
        @activity.process
        @activity.processed?.should be_true
      end
    end
  end
end
