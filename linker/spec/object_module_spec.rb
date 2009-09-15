require File.dirname(__FILE__) + '/spec_helper'

describe ObjectModule do
  describe "initialize" do
    it "should set size" do
      ObjectModule.new(5).size.should == 5
    end
  end
end
