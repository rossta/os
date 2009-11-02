require File.dirname(__FILE__) + '/spec_helper'

describe Task do
  describe "add_activity" do
    it "should increment activities size" do
      task = Task.new
      task.add_activity(:activity)
      task.activities.size.should == 1
    end
    it "should add activity to activities" do
      task = Task.new
      task.add_activity(:activity)
      task.activities.first.should == :activity
    end
  end
  
  describe "next_activity" do
    it "should return next unprocessed activity" do
      task = Task.new
      task.add_activity(mock(TaskActivity, :processed? => true))
      next_activity = mock(TaskActivity, :processed? => false)
      task.add_activity(next_activity)
      task.add_activity(mock(TaskActivity, :processed? => false))
      task.next_activity.should == next_activity
    end
  end

  describe "initial_claim" do
    it "should return initial claim array from initiate commands" do
      task = Task.new
      task.add_activity(mock(TaskActivity,
        :name => TaskActivity::INITIATE,
        :units => 2,
        :resource_type => 1))
      task.add_activity(mock(TaskActivity,
        :name => TaskActivity::INITIATE,
        :units => 3,
        :resource_type => 2))
      task.add_activity(mock(TaskActivity,
        :name => TaskActivity::REQUEST,
        :units => 3,
        :resource_type => 1))

      task.initial_claim.should == [2, 3]
    end
  end
  
  describe "terminated?" do
    it "should be false if non-processed activities remain" do
      task = Task.new
      task.add_activity(mock(TaskActivity, :processed? => true))
      task.add_activity(mock(TaskActivity, :processed? => false))
      task.add_activity(mock(TaskActivity, :processed? => false))
      task.terminated?.should be_false
    end
    it "should be true if next activity is terminate" do
      task = Task.new
      task.add_activity(mock(TaskActivity, :processed? => true))
      task.add_activity(mock(TaskActivity, :processed? => true))
      task.terminated?.should be_true
    end
    it "should be false if no activities" do
      Task.new.terminated?.should be_true
    end
  end
  
  describe "terminate_if_processed" do
    it "should process next activity if terminate" do
      task = Task.new
      terminate = mock(TaskActivity, :name => TaskActivity::TERMINATE, :processed? => false)
      task.add_activity(mock(TaskActivity, :name => TaskActivity::REQUEST, :processed? => true))
      task.add_activity(terminate)
      terminate.should_receive(:process).exactly(1).times
      task.terminate_if_processed
    end
    
    it "should not be process next activity if not terminate" do
      task = Task.new
      next_activity = mock(TaskActivity, :name => TaskActivity::REQUEST, :processed? => false)
      terminate = mock(TaskActivity, :name => TaskActivity::TERMINATE, :processed? => false)
      task.add_activity(next_activity)
      task.add_activity(terminate)
      next_activity.should_not_receive(:process)
      terminate.should_not_receive(:process)
      task.terminate_if_processed
    end
  end
  
  describe "total_time" do
    it "should return total time" do
      task = Task.new
      task.total_time.should == 0
    end
  end
  
  describe "wait_time" do
    it "should return time waiting" do
      task = Task.new
      task.wait_time.should == 0
    end
  end
  
  describe "percent_waiting" do
    it "should return wait_time / total_time" do
      task = Task.new
      task.wait_time = 3
      task.total_time = 5
      task.percent_waiting.should == 60
    end
  end
end
