require File.dirname(__FILE__) + '/spec_helper'

describe Resource do
  describe "units" do
    it "should return unallocated units" do
      Resource.new(4).units.should == 4
    end
  end
  
  describe "max" do
    it "should always equal initial units" do
      Resource.new(4).max.should == 4
    end
  end
  
  describe "request" do
    it "should return units requested" do
      r = Resource.new(4)
      r.request(2).should == 2
    end
    
    it "should decrement units count" do
      r = Resource.new(4)
      r.request(2)
      r.units.should == 2
    end
    
    it "should raise error if requesting more than available" do
      r = Resource.new(4)
      lambda { r.request(5) }.should raise_error
    end
  end
  
  describe "replenish" do
    it "should increment units count" do
      r = Resource.new(4)
      r.request(3)
      r.replenish(2)
      r.units.should == 3
    end
    
    it "should not allow replenish to exceed total" do
      r = Resource.new(4)
      lambda { r.replenish(1) }.should raise_error
    end
  end
end
