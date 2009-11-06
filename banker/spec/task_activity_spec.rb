require File.dirname(__FILE__) + '/spec_helper'

describe TaskActivity do
  describe "name" do
    it "should return initiate for TaskActivity::Initiate" do
      TaskActivity::Initiate.new(mock(Task), 0,0).name.should == "initiate"
    end
    it "should return terminate for TaskActivity::Terminate" do
      TaskActivity::Terminate.new(mock(Task)).name.should == "terminate"
    end
  end

  describe "Base" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Base.new(mock(Task),1,2)
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
        @activity = TaskActivity::Terminate.new(mock(Task),1,2)
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
      @task = mock(Task, :allocate => {})
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
  end
  describe "Release" do
    before(:each) do
      @resource = mock(Resource, :resource_type => 1, :units => 4)
      ResourceTable.stub!(:find).and_return(@resource)
      ResourceTable.stub!(:replenish)
      @task = mock(Task, :release => 3)
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
      @task = mock(Task)
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
