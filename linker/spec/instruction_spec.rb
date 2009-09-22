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
  
  describe "update_address" do
    describe "validate machine size" do
      it "should set address to 0 if greater than machine size and not I" do
        instr = Instruction.new(:type, 7999)
        instr.update_address
        instr.errors.should_not be_empty
      end
      
      it "should not have machine size error if type I" do
        instr = Instruction.new("I", 7999)
        instr.update_address
        instr.errors.should be_empty
      end
      it "should not have error if less than machine size" do
        instr = Instruction.new(:type, 7599)
        instr.update_address
        instr.errors.should be_empty
      end

      it "should have error if greater than machine size" do
        instr = Instruction.new(:type, 7999)
        instr.update_address
        instr.errors.should include("Error: Absolute address exceeds machine size; zero used.")
      end

      it "should set error to 0" do
        instr = Instruction.new(:type, 7999)
        instr.update_address
        instr.address.should == 0
      end
      
    end
    
    describe "type R" do
      it "should add base address to address" do
        instr = Instruction.new("R", 5009)
        instr.update_address(:symbol => "x", :base_address => 3, :size => 10)
        instr.address.should == 12
      end
      describe "validation" do
        it "should set address to 0 if relative address > module size" do
          instr = Instruction.new("R", 5006)
          instr.update_address(:symbol => "x", :base_address => 1, :size => 5)
          instr.address.should == 0
        end
        it "should add error if relative address > module size" do
          instr = Instruction.new("R", 5006)
          instr.update_address(:symbol => "x", :base_address => 1, :size => 5)
          instr.errors[0].should == "Error: Relative address exceeds module size; zero used."
        end
      end
    end
    describe "type E" do
      it "should set to external address defined by symbol" do
        SymbolTable.stub!(:address).with("x").and_return(15)
        SymbolTable.stub!(:address).with("y").and_return(4)
        instr = Instruction.new("E", 5005)
        instr.update_address(:symbol => "x", :base_address => 3)
        instr.address.should == 15
      end
      it "should set to external address, non-zero index" do
        SymbolTable.stub!(:address).with("x").and_return(15)
        SymbolTable.stub!(:address).with("y").and_return(4)
        instr = Instruction.new("E", 2001)
        instr.update_address(:symbol => "y", :base_address => 3)
        instr.address.should == 4
      end
      describe "symbol not defined" do
        before(:each) do
          SymbolTable.stub!(:address).with("x").and_return(nil)
          SymbolTable.stub!(:address).with("y").and_return(15)
          @instr = Instruction.new("E", 2006)
          @instr.update_address(:symbol => "x", :base_address => 3)
        end
        it "should add an error" do
          @instr.errors.size.should == 1
        end
        it "should have correct error text" do
          @instr.errors[0].should == "Error: x is not defined; zero used."
        end
        it "should set address to 0" do
          @instr.address.should == 0
        end
      end
    end
    
  end
  
end