require File.dirname(__FILE__) + '/spec_helper'

describe AddressParser do
  
  describe "initialize" do
    it "should set reader" do
      reader = mock(Reader)
      parser = AddressParser.new(reader)
      parser.reader.should == reader
    end
  end
  
  describe "symbols" do
    describe "after parsing" do
      it "should return 2 for symbols['xy']" do
        parser = AddressParser.new(Reader.new(FIXTURES + 'input_1.txt'))
        parser.parse
      
        parser.symbols['xy'].should == 2
      end
    
      # it "should return 15 for symbols['z']" do
      #   parser = AddressParser.new(Reader.new(FIXTURES + 'input_1.txt'))
      #   parser.parse
      # 
      #   parser.symbols['z'].should == 15
      # end
    end
  end
  
  describe "consume_module" do
  end
  
end
