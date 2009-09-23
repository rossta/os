require File.dirname(__FILE__) + '/spec_helper'

describe ProgramModule do
  describe "initialize" do
    it "should set base address" do
      ProgramModule.new(10).base_address.should == 10
    end
  end

  describe "uses" do
    it "should return array of uses" do
      ProgramModule.new.uses.should == []
    end
    it "should return array of uses" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses == ['a', 'b']
    end
  end
  
  describe "unused_symbols" do
    it "should return symbols not used by e instructions" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses << 'c'
      mod.uses << 'd'
      
      mod.instructions << mock(Instruction, :type => "E", :symbol => "a", :valid? => true)
      mod.instructions << mock(Instruction, :type => "E", :symbol => "b", :valid? => true)
      mod.instructions << mock(Instruction, :type => "E", :symbol => "b", :valid? => true)
      
      mod.unused_symbols.size.should == 2
      mod.unused_symbols.should include('c')
      mod.unused_symbols.should include('d')
    end
    it "should not return symbols for invalid Es" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses << 'c'
      
      mod.instructions << mock(Instruction, :type => "E", :symbol => "a", :valid? => false)
      mod.instructions << mock(Instruction, :type => "E", :symbol => "b", :valid? => false)
      mod.instructions << mock(Instruction, :type => "E", :symbol => "b", :valid? => false)
      
      mod.unused_symbols.size.should == 0
    end
    it "should return symbols e instructions" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      
      mod.instructions << mock(Instruction, :type => "R", :symbol => "a", :valid? => true)
      mod.instructions << mock(Instruction, :type => "I", :symbol => "b", :valid? => true)
      
      mod.unused_symbols.size.should == 2
    end
  end

  describe "create_instruction" do
    before(:each) do
      @mod = ProgramModule.new
    end
    it "should return new Instruction" do
      @mod.create_instruction("R", 1234)
      @mod.instructions.first.should be_an_instance_of(Instruction)
    end

    it "should return instruction with type" do
      @mod.create_instruction("R", 1234)
      @mod.instructions.first.type.should == "R"
    end
    it "should return instruction with address" do
      @mod.create_instruction("R", 1234)
      @mod.instructions.first.word.should == 1234
    end
  end

  describe "to_s" do
    it "should print instructions numbered from base address 0" do
      mod = ProgramModule.new(0)
      mod.instructions << mock(Instruction, :to_s => "1000")
      mod.instructions << mock(Instruction, :to_s => "1020")
      mod.instructions << mock(Instruction, :to_s => "1012")
      mod.to_s.should == "0:  1000\n1:  1020\n2:  1012"
    end
    it "should print instructions numbered from base address 3" do
      mod = ProgramModule.new(3)
      mod.instructions << mock(Instruction, :to_s => "1000")
      mod.instructions << mock(Instruction, :to_s => "1020")
      mod.instructions << mock(Instruction, :to_s => "1012")
      mod.to_s.should == "3:  1000\n4:  1020\n5:  1012"
    end
  end
  
  describe "defines?" do
    it "should return true if symbol is in module symbols" do
      mod = ProgramModule.new
      mod.symbols = { :x => 1, :y => 2 }
      mod.defines?(:x).should be_true
    end
    
    it "should return false if symbol is not in module symbols" do
      mod = ProgramModule.new
      mod.symbols = { :x => 1, :y => 2 }
      mod.defines?(:z).should be_false
    end
  end

end
