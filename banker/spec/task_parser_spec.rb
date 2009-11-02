require File.dirname(__FILE__) + '/spec_helper'

describe TaskParser do
  
  describe "parse" do
    describe "input 1: 2 tasks, 1 resource" do
      before(:each) do
        @parser = TaskParser.new(FIXTURES + "input_1.txt")
      end
      
      describe "initializing task and resources" do
        before(:each) do
          Resource.stub!(:new).and_return(:resource)
          Task.stub!(:new).and_return(mock(Task, :add_activity => nil))
        end
        it "should create two tasks" do
          @parser.parse
          @parser.tasks.size.should == 2
        end
      
        it "should create 1 resource" do
          Resource.stub!(:new).and_return(:resource)
          @parser.parse
          @parser.resources.size.should == 1
        end
      
        it "should set resource units to 4" do
          Resource.should_receive(:new).with(4, 1).and_return(mock(Resource))
          @parser.parse
        end
      end
      
      describe "task activities" do
        before(:each) do
          Resource.stub!(:new).and_return(mock(Resource))
          Task.stub!(:new).and_return(@task1 = mock(Task, :add_activity => nil), @task2 = mock(Task, :add_activity => nil))
          TaskActivity::Initiate.stub!(:new  ).and_return(:activity1, :activity5)
          TaskActivity::Request.stub!(:new   ).and_return(:activity2, :activity6)
          TaskActivity::Release.stub!(:new   ).and_return(:activity3, :activity7)
          TaskActivity::Terminate.stub!(:new ).and_return(:activity4, :activity8)
        end
        
        it "should add activities to task 1" do
          @task1.should_receive(:add_activity).with(:activity1)
          @task1.should_receive(:add_activity).with(:activity2)
          @task1.should_receive(:add_activity).with(:activity3)
          @task1.should_receive(:add_activity).with(:activity4)
          @parser.parse
        end
        
        it "should add activities to task 2" do
          @task2.should_receive(:add_activity).with(:activity5)
          @task2.should_receive(:add_activity).with(:activity6)
          @task2.should_receive(:add_activity).with(:activity7)
          @task2.should_receive(:add_activity).with(:activity8)
          @parser.parse
        end
      end
    end
    
    describe "input 9: 2 tasks, 2 resources" do
      before(:each) do
        @parser = TaskParser.new(FIXTURES + "input_9.txt")
        Resource.stub!(:new).and_return(:resource)
        Task.stub!(:new).and_return(mock(Task, :add_activity => nil))
      end
      
      it "should create two tasks" do
        @parser.parse
        @parser.tasks.size.should == 2
      end
      
      it "should create 1 resource" do
        Resource.stub!(:new).and_return(:resource)
        @parser.parse
        @parser.resources.size.should == 2
      end
      
      it "should set resource units to 4" do
        Resource.should_receive(:new).exactly(1).times.with(4, 1).and_return(mock(Resource))
        Resource.should_receive(:new).exactly(1).times.with(4, 2).and_return(mock(Resource))
        @parser.parse
      end
    end
  end
  
end

describe TaskParser::ActivityFactory do
  describe "self.create_for" do
    before(:each) do
      @parser = mock(TaskParser)
      @parser.stub!(:parse_number).and_return(1, 2, 3)
    end
    describe "initiate" do
      it "should create an initiate activity" do
        TaskActivity::Initiate.should_receive(:new).with(1, 2).and_return(:activity)
        TaskParser::ActivityFactory.create_for("initiate", @parser).should == :activity
      end
    end
    describe "terminate" do
      it "should create a terminate activity" do
        TaskActivity::Terminate.should_receive(:new).with().and_return(:activity)
        TaskParser::ActivityFactory.create_for("terminate", @parser).should == :activity
      end
    end
    describe "request" do
      it "should create a request activity" do
        TaskActivity::Request.should_receive(:new).with(1, 2).and_return(:activity)
        TaskParser::ActivityFactory.create_for("request", @parser).should == :activity
      end
    end
    describe "release" do
      it "should create a request activity" do
        TaskActivity::Release.should_receive(:new).with(1, 2).and_return(:activity)
        TaskParser::ActivityFactory.create_for("release", @parser).should == :activity
      end
    end
    describe "compute" do
      it "should create a request activity" do
        TaskActivity::Compute.should_receive(:new).with(1).and_return(:activity)
        TaskParser::ActivityFactory.create_for("compute", @parser).should == :activity
      end
    end
  end
end
