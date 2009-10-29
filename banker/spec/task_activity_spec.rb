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
end
