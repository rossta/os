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
  
  describe "create_instruction" do
    it "should return new ProgramModule::Instruction" do
      ProgramModule.new.create_instruction("R", "1234").should be_an_instance_of(ProgramModule::Instruction)
    end
    
    it "should return instruction with type" do
      instruction = ProgramModule.new.create_instruction("R", "1234")
      instruction.type.should == "R"
    end
    it "should return instruction with address" do
      instruction = ProgramModule.new.create_instruction("R", "1234")
      instruction.word.should == "1234"
    end
  end
  
  describe "to_s" do
    it "should print instructions numbered from base address 0" do
      mod = ProgramModule.new(0)
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1000")
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1020")
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1012")
      mod.to_s.should == "0:  1000\n1:  1020\n2:  1012\n"
    end
    it "should print instructions numbered from base address 3" do
      mod = ProgramModule.new(3)
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1000")
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1020")
      mod.instructions << mock(ProgramModule::Instruction, :to_s => "1012")
      mod.to_s.should == "3:  1000\n4:  1020\n5:  1012\n"
    end
  end
  
  describe "Instruction" do
    describe "address" do
      it "should return 123 given word is '7123'" do
        inst = ProgramModule::Instruction.new(:type, "7123")
        inst.address.should == 123
      end
    end
    
    describe "op_code" do
      it "should return 7 given word is 7123" do
        inst = ProgramModule::Instruction.new(:type, "7123")
        inst.op_code.should == 7
      end
    end
    
    describe "to_s" do
      it "should print 7123" do
        inst = ProgramModule::Instruction.new(:type, "7123")
        inst.to_s.should == "7123"
      end
      it "should print 7001" do
        inst = ProgramModule::Instruction.new(:type, "7001")
        inst.to_s.should == "7001"
      end
      it "should print 7000 with error" do
        inst = ProgramModule::Instruction.new(:type, "7000")
        inst.errors <<  "Error: Absolute address exceeds machine size; zero used."
        inst.to_s.should == "7000 Error: Absolute address exceeds machine size; zero used."
      end
    end
  end
end
