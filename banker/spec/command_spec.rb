require File.dirname(__FILE__) + '/spec_helper'

describe Command do
  
  describe "name" do
    it "should return initiate for Command::Initiate" do
      Command::Initiate.new(0,0).name.should == "initiate"
    end
    it "should return terminate for Command::Terminate" do
      Command::Terminate.new.name.should == "terminate"
    end
  end
end
