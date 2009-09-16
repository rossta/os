require File.dirname(__FILE__) + '/spec_helper'

describe ObjectModule do
  describe "initialize" do
    it "should set base address" do
      ObjectModule.new(10).base_address.should == 10
    end
  end
  
  describe "uses" do
    it "should return array of uses" do
      ObjectModule.new(10).uses.should == []
    end
    it "should return array of uses" do
      mod = ObjectModule.new(10)
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses == ['a', 'b']
    end
  end
end
