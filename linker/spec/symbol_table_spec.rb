require File.dirname(__FILE__) + '/spec_helper'

describe SymbolTable do
  describe "[]=" do
    it "should return value for key" do
      table = SymbolTable.new
      table[:key] = :value
      table[:key].should == :value
    end
  end
  
  describe "to_s" do
    it "should output values" do
      table = SymbolTable.new
      table["xy"] = 2
      table["z"]  = 15
      
      table.to_s.should == "Symbol Table\nxy=2\nz=15\n"
    end
    
    it "should output errors with values" do
      table = SymbolTable.new
      table["X21"] = 3
      table.errors["X21"] = "Error: This variable is multiply defined; first value used."
      
      table.to_s.should == "Symbol Table\nX21=3 Error: This variable is multiply defined; first value used.\n"
    end
  end
end
