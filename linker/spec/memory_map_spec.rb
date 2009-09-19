require File.dirname(__FILE__) + '/spec_helper'

describe MemoryMap do
  
  before(:each) do
    MemoryMap.clear!
  end
  
  describe "<<" do
    it "should append module" do
      map = MemoryMap.memory
      map << :object_module
      map[0].should == :object_module
    end
  end
  
  describe "[]=" do
    it "should set modules" do
      map = MemoryMap.memory
      map = [:object_module]
      map[0].should == :object_module
    end
  end
  
  describe "to_s" do
    it "should output values" do
      map = MemoryMap.memory
      map << mock(ProgramModule, :to_s => "0:  1004")
      map << mock(ProgramModule, :to_s => "1:  5678")
      map << mock(ProgramModule, :to_s => "2:  2015")

      map.to_s.should == "Memory Map\n0:  1004\n1:  5678\n2:  2015"
    end
  end
end
