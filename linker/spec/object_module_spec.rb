require File.dirname(__FILE__) + '/spec_helper'

describe ObjectModule do
  describe "initialize" do
    it "should set base address" do
      ObjectModule.new(10).base_address.should == 10
    end
  end
  
  describe "uses" do
    it "should return array of uses" do
      ObjectModule.new.uses.should == []
    end
    it "should return array of uses" do
      mod = ObjectModule.new
      mod.uses << 'a'
      mod.uses << 'b'
      mod.uses == ['a', 'b']
    end
  end
  
  describe "create_instruction" do
    it "should return new ObjectModule::Instruction" do
      ObjectModule.new.create_instruction(:type, :word).should be_an_instance_of(ObjectModule::Instruction)
    end
    
    it "should return instruction with type" do
      instruction = ObjectModule.new.create_instruction(:type, :word)
      instruction.type.should == :type
    end
    it "should return instruction with address" do
      instruction = ObjectModule.new.create_instruction(:type, :word)
      instruction.word.should == :word
    end
  end
  
  describe "Instruction" do
    describe "address" do
      it "should return 123 given word is '7123'" do
        inst = ObjectModule::Instruction.new(:type, "7123")
        inst.address.should == 123
      end
    end
    
    describe "errors" do
      it "should be appendable" do
        inst = ObjectModule::Instruction.new(:type, "7123")
        inst.errors << "Error test"
        inst.errors.should == ["Error test"]
      end
    end
    
    describe "error_message" do
      it "should join errors to string" do
        inst = ObjectModule::Instruction.new(:type, "7123")
        inst.errors << "Error test 1"
        inst.errors << "Error test 2"
        inst.error_message.should == "Error test 1. Error test 2"
      end
    end
  end
end
