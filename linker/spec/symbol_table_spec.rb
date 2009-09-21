require File.dirname(__FILE__) + '/spec_helper'

describe SymbolTable do
  before(:each) do
    @table = SymbolTable.table
  end
  
  after(:each) do
    SymbolTable.clear!
  end
  
  describe "self.symbols" do
    it "should return same instance of symbol table" do
      SymbolTable.table.should == SymbolTable.table
    end
  end
  
  describe "[]=" do
    it "should return value for key" do
      @table[:key] = :value
      @table[:key].should == :value
    end
  end
  
  describe "to_s" do
    it "should output values" do
      @table["xy"] = 2
      @table["z"]  = 15
      
      @table.to_s.should == "Symbol Table\nxy=2\nz=15"
    end
    
    it "should output errors with values" do
      @table["X21"] = 3
      @table.errors["X21"] = "Error: This variable is multiply defined; first value used."
      
      @table.to_s.should == "Symbol Table\nX21=3 Error: This variable is multiply defined; first value used."
    end
    
    it "should print in alphabetical order" do
      @table["X23"] = 23
      @table["X13"] = 13
      @table["X34"] = 34
      @table["X12"] = 12
      
      @table.to_s.should == "Symbol Table\nX12=12\nX13=13\nX23=23\nX34=34"
    end
  end
  
end
