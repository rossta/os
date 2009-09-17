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
      ProgramModule.new.create_instruction(:type, :word).should be_an_instance_of(ProgramModule::Instruction)
    end
    
    it "should return instruction with type" do
      instruction = ProgramModule.new.create_instruction(:type, :word)
      instruction.type.should == :type
    end
    it "should return instruction with address" do
      instruction = ProgramModule.new.create_instruction(:type, :word)
      instruction.word.should == :word
    end
  end
  
  describe "Instruction" do
    describe "address" do
      it "should return 123 given word is '7123'" do
        inst = ProgramModule::Instruction.new(:type, "7123")
        inst.address.should == 123
      end
    end
    
  end
end
