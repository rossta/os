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

  describe "map" do
    it "should add base address for instruction type R" do
      mod = ProgramModule.new(4)
      instr = mod.create_instruction("R", 1500)
      mod.map
      instr.address.should == 504
      instr.word.should == 1504
    end
    it "should set symbol address for instruction type E" do
      mod = ProgramModule.new
      mod.uses << "x"
      SymbolTable.symbols["x"] = 15
      instr = mod.create_instruction("E", 2000)
      mod.map
      instr.address.should == 15
      instr.word.should == 2015
    end
    it "should set symbol address for instruction type E" do
      mod = ProgramModule.new
      mod.uses << "x"
      mod.uses << "y"
      SymbolTable.symbols["x"] = 15
      SymbolTable.symbols["y"] = 4
      instr = mod.create_instruction("E", 2001)
      mod.map
      instr.address.should == 4
      instr.word.should == 2004
    end
    it "should leave symbol address alone for instruction type A" do
      mod = ProgramModule.new
      instr = mod.create_instruction("A", 2007)
      mod.map
      instr.address.should == 7
      instr.word.should == 2007
    end
    it "should leave symbol address alone for instruction type I" do
      mod = ProgramModule.new
      instr = mod.create_instruction("I", 2007)
      mod.map
      instr.address.should == 7
      instr.word.should == 2007
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
      mod.to_s.should == "0:  1000\n1:  1020\n2:  1012\n"
    end
    it "should print instructions numbered from base address 3" do
      mod = ProgramModule.new(3)
      mod.instructions << mock(Instruction, :to_s => "1000")
      mod.instructions << mock(Instruction, :to_s => "1020")
      mod.instructions << mock(Instruction, :to_s => "1012")
      mod.to_s.should == "3:  1000\n4:  1020\n5:  1012\n"
    end
  end

end
