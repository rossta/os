require File.dirname(__FILE__) + '/spec_helper'

describe Linker do
  describe "clear" do
    it "should clear the symbol table" do
      linker = Linker.new(FIXTURES + 'input_1.txt')
      SymbolTable.should_receive(:clear!)
      linker.clear!
    end
    it "should clear the memory map" do
      linker = Linker.new(FIXTURES + 'input_1.txt')
      MemoryMap.should_receive(:clear!)
      linker.clear!
    end
  end
  describe "link" do
    describe "input 1" do
      it "should match output 1" do
        linker = Linker.new(FIXTURES + 'input_1.txt')
        linker.link
        linker.to_s.should == File.open(FIXTURES + 'output_1.txt').read
      end
    end
    describe "input 2" do
      it "should match output 2" do
        linker = Linker.new(FIXTURES + 'input_2.txt')
        linker.link
        linker.to_s.should == File.open(FIXTURES + 'output_2.txt').read
      end
    end
  end
end
