require File.dirname(__FILE__) + '/spec_helper'

describe TaskActivity do

  describe "name" do
    it "should return initiate for TaskActivity::Initiate" do
      TaskActivity::Initiate.new(0,0).name.should == "initiate"
    end
    it "should return terminate for TaskActivity::Terminate" do
      TaskActivity::Terminate.new.name.should == "terminate"
    end
  end

  describe "Base" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Base.new(1,2)
      end
      it "should mark as processed" do
        @activity.process(mock(Task), [:resources])
        @activity.processed?.should be_true
      end
    end
  end
  
  describe "Initiate" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Initiate.new(1,2)
      end
    end
  end
  
  describe "Terminate" do
    describe "process" do
      before(:each) do
        @activity = TaskActivity::Terminate.new(1,2)
      end
      
      it "should mark processed" do
        @activity.process
        @activity.processed?.should be_true
      end
    end
  end
  describe "Request" do
    before(:each) do
      @activity = TaskActivity::Request.new(1,2)
      @resource = mock(Resource, :resource_type => 1, :request => 2, :units => 3, :replenish => nil)
    end
    describe "process" do
      it "should request units" do
        @resource.should_receive(:request).with(2).exactly(1).times
        @activity.process(mock(Task, :allocate => nil), [@resource, mock(Resource, :resource_type => 2)])
      end
      it "should mark processed" do
        @activity.process(mock(Task, :allocate => nil), [@resource])
        @activity.processed?.should be_true
      end
      it "should allocate units to task" do
        task = mock(Task)
        task.should_receive(:allocate).with(1, 2).exactly(1).times
        @activity.process(task, [@resource])
      end
    end
  end
  describe "Release" do
    before(:each) do
      @activity = TaskActivity::Release.new(1,3)
    end
    
    describe "process" do
      it "should request units" do
        resource = mock(Resource, :resource_type => 1, :units => 4)
        resource.should_receive(:replenish).with(3).exactly(1).times
        @activity.process(mock(Task, :release => 3), [resource, mock(Resource, :resource_type => 2)])
      end
      it "should mark processed" do
        @activity.process(mock(Task, :release => 3), [mock(Resource, :resource_type => 1, :replenish => 2, :units => 4)])
        @activity.processed?.should be_true
      end
      it "should allocate units to task" do
        task = mock(Task)
        task.should_receive(:release).with(1, 3).exactly(1).times
        @activity.process(task, [mock(Resource, :resource_type => 1, :replenish => 3)])
      end
    end
  end
end
