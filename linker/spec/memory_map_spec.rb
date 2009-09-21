require File.dirname(__FILE__) + '/spec_helper'

describe MemoryMap do

  before(:each) do
    MemoryMap.clear!
  end

  describe "create_program_module" do
    it "should create new program module" do
      ProgramModule.should_receive(:new).and_return(mock(ProgramModule, :symbols= => nil))
      MemoryMap.create_program_module(0)
    end

    it "should add module to memory map" do
      MemoryMap.create_program_module(0)
      MemoryMap.memory.size.should == 1
    end
  end

  describe "validate!" do
    before(:each) do
      MemoryMap.memory << mock(ProgramModule, :uses => ["X23"], :defines? => false)
      MemoryMap.memory << mock(ProgramModule, :uses => ["X24"], :defines? => true)
      SymbolTable.stub!(:symbols).and_return({"X23" => 23, "X24" => 24, "Unused" => 0})
    end

    it "should validate all symbols are used" do
      MemoryMap.validate!
      MemoryMap.warnings.should_not be_empty
    end

    it "should warn that symbol was uses but never used" do
      MemoryMap.validate!
      MemoryMap.warnings.should include("Warning: Unused was defined in module 2 but never used.")
    end
  end

  describe "all_uses" do
    before(:each) do
      MemoryMap.memory << mock(ProgramModule, :uses => [:x, :y])
      MemoryMap.memory << mock(ProgramModule, :uses => [:y, :z])
      MemoryMap.memory << mock(ProgramModule, :uses => [:a, :x])
    end

    it "should return one of each symbol" do
      MemoryMap.all_uses.size.should == 4
    end

    it "should all symbols in program module use lists" do
      # MemoryMap.all_uses.should include([:x, :y])
      # MemoryMap.all_uses.should include([:y, :z])
      # MemoryMap.all_uses.should include([:a, :x])
      MemoryMap.all_uses.should include(:x)
      MemoryMap.all_uses.should include(:y)
      MemoryMap.all_uses.should include(:z)
      MemoryMap.all_uses.should include(:a)
    end
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
