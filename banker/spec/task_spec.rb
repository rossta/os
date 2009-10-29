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
end
