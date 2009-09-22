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
  
  describe "unused_uses" do
    it "should return symbols in use list not instruction" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses << 'c'
      mod.uses << 'd'
      
      mod.create_instruction("E", 1000)
      mod.create_instruction("E", 2001)
      mod.create_instruction("E", 3001)
      
      mod.unused_uses.size.should == 2
      mod.unused_uses.should include('c')
      mod.unused_uses.should include('d')
    end
    it "should return empty if no valid e instructions" do
      mod = ProgramModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      
      mod.create_instruction("R", 1000)
      mod.create_instruction("I", 2001)
      
      mod.unused_uses.size.should == 0
    end
  end

  describe "create_instruction" do
    it "should return new Instruction" do
      ProgramModule.new.create_instruction("R", 1234).should be_an_instance_of(Instruction)
    end

    it "should return instruction with type" do
      instruction = ProgramModule.new.create_instruction("R", 1234)
      instruction.type.should == "R"
    end
    it "should return instruction with address" do
      instruction = ProgramModule.new.create_instruction("R", 1234)
      instruction.word.should == 1234
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
