require File.dirname(__FILE__) + '/spec_helper'

describe "Instruction" do
  describe "address" do
    it "should return 123 given word is '7123'" do
      instr = Instruction.new(:type, 7123)
      instr.address.should == 123
    end
  end
  
  describe "op_code" do
    it "should return 7 given word is 7123" do
      instr = Instruction.new(:type, 7123)
      instr.op_code.should == 7
    end
  end
  
  describe "word" do
    it "should calculate opcode + word" do
      instr = Instruction.new(:type, 2005)
      instr.address += 10
      instr.word.should == 2015
    end
  end
  
  describe "to_s" do
    it "should print 7123" do
      instr = Instruction.new(:type, 7123)
      instr.to_s.should == "7123"
    end
    it "should print 7001" do
      instr = Instruction.new(:type, 7001)
      instr.to_s.should == "7001"
    end
    it "should print 7000 with error" do
      instr = Instruction.new(:type, 7000)
      instr.errors <<  "Error: Absolute address exceeds machine size; zero used."
      instr.to_s.should == "7000 Error: Absolute address exceeds machine size; zero used."
    end
  end
  
  describe "validate!" do
    it "should not have error if less than machine size" do
      instr = Instruction.new(:type, 7599)
      instr.validate!
      instr.errors.should be_empty
    end

    it "should have error if greater than machine size" do
      instr = Instruction.new(:type, 7999)
      instr.validate!
      instr.errors.should include("Error: Absolute address exceeds machine size; zero used.")
    end
    
    it "should not have machine size error if type I" do
      instr = Instruction.new("I", 7999)
      instr.validate!
      instr.errors.should be_empty
    end

    it "should set error to 0" do
      instr = Instruction.new(:type, 7999)
      instr.validate!
      instr.address.should == 0
    end
  end
  
end