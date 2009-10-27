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
          Task.stub!(:new).and_return(mock(Task, :add_command => nil))
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
          Resource.should_receive(:new).with(4).and_return(mock(Resource))
          @parser.parse
        end
      end
      
      describe "task commands" do
        before(:each) do
          Resource.stub!(:new).and_return(mock(Resource))
          Task.stub!(:new).and_return(@task1 = mock(Task, :add_command => nil), @task2 = mock(Task, :add_command => nil))
          Command::Initiate.stub!(:new  ).and_return(:command1, :command5)
          Command::Request.stub!(:new   ).and_return(:command2, :command6)
          Command::Release.stub!(:new   ).and_return(:command3, :command7)
          Command::Terminate.stub!(:new ).and_return(:command4, :command8)
        end
        
        it "should add commands to task 1" do
          @task1.should_receive(:add_command).with(:command1)
          @task1.should_receive(:add_command).with(:command2)
          @task1.should_receive(:add_command).with(:command3)
          @task1.should_receive(:add_command).with(:command4)
          @parser.parse
        end
        
        it "should add commands to task 2" do
          @task2.should_receive(:add_command).with(:command5)
          @task2.should_receive(:add_command).with(:command6)
          @task2.should_receive(:add_command).with(:command7)
          @task2.should_receive(:add_command).with(:command8)
          @parser.parse
        end
      end
    end
    
    describe "input 9: 2 tasks, 2 resources" do
      before(:each) do
        @parser = TaskParser.new(FIXTURES + "input_9.txt")
        Resource.stub!(:new).and_return(:resource)
        Task.stub!(:new).and_return(mock(Task, :add_command => nil))
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
        Resource.should_receive(:new).exactly(2).times.with(4).and_return(mock(Resource))
        @parser.parse
      end
    end
  end
  
end

describe TaskParser::CommandFactory do
  describe "self.create_for" do
    before(:each) do
      @parser = mock(TaskParser)
      @parser.stub!(:parse_number).and_return(1, 2, 3)
    end
    describe "initiate" do
      it "should create an initiate command" do
        Command::Initiate.should_receive(:new).with(1, 2).and_return(:command)
        TaskParser::CommandFactory.create_for("initiate", @parser).should == :command
      end
    end
    describe "terminate" do
      it "should create a terminate command" do
        Command::Terminate.should_receive(:new).with().and_return(:command)
        TaskParser::CommandFactory.create_for("terminate", @parser).should == :command
      end
    end
    describe "request" do
      it "should create a request command" do
        Command::Request.should_receive(:new).with(1, 2).and_return(:command)
        TaskParser::CommandFactory.create_for("request", @parser).should == :command
      end
    end
    describe "release" do
      it "should create a request command" do
        Command::Release.should_receive(:new).with(1, 2).and_return(:command)
        TaskParser::CommandFactory.create_for("release", @parser).should == :command
      end
    end
    describe "compute" do
      it "should create a request command" do
        Command::Compute.should_receive(:new).with(1).and_return(:command)
        TaskParser::CommandFactory.create_for("compute", @parser).should == :command
      end
    end
  end
end
