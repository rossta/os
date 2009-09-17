require File.dirname(__FILE__) + '/spec_helper'

module AddressParserHelper
  def parser_symbols_should_equal_symbols(input, symbols)
    parser = AddressParser.new(Linker.new(FIXTURES + input))
    parser.parse
    symbols.keys.each do |key|
      parser.symbols[key].should == symbols[key]
    end
  end
  
  def parser_base_addresses_should_equal(parser, addresses)
    addresses.each_with_index do |addr, i|
      parser.modules[i].base_address.should == addr
    end
  end
end

describe AddressParser do
  include AddressParserHelper
  
  describe "initialize" do
    it "should set reader" do
      parser = AddressParser.new(:linker)
      parser.linker.should == :linker
    end
  end
  
  describe "symbols" do
    describe "input 1" do
      it "should return correct values for input 1 symbols" do
        symbols = { "xy" => 2, "z" => 15 }
        parser_symbols_should_equal_symbols('input_1.txt', symbols)
      end
    end
    
    describe "input 2" do
      it "should return correct values for input 2 symbols" do
        symbols = { "xy" => 2, "z" => 15 }
        parser_symbols_should_equal_symbols('input_2.txt', symbols)
      end
    end
    
    describe "input 3" do
      it "should return correct values for input 3 symbols" do
       symbols = {
         "X11" => 6, "X12" => 8, "X13" => 9,
         "X21" => 10,"X22" => 12,"X23" => 15,
         "X31" => 20,"X61" => 32
        }
        parser_symbols_should_equal_symbols('input_3.txt', symbols)
      end
    end

    describe "input 4" do
      it "should return correct values for input 4 symbols" do
        symbols = { "X21" => 3 }
        parser_symbols_should_equal_symbols('input_4.txt', symbols)
      end
      
      describe "errors" do
        it "should return multiply defined error on symbols['X21']" do
          parser = AddressParser.new(Linker.new(FIXTURES + 'input_4.txt'))
          parser.parse
          parser.errors['X21'].should == "This variable is multiply defined; first value used."
        end
      end
    end

    describe "input 5" do
      it "should return correct values for input 5 symbols" do
        symbols = { "X31" => 4 }
        parser_symbols_should_equal_symbols('input_5.txt', symbols)
      end
    end

    describe "input 9" do
      it "should return correct values for input 9 symbols" do
        symbols = { "X21" => 1 }
        parser_symbols_should_equal_symbols('input_9.txt', symbols)
      end
    end

    describe "input 6" do
      it "should return correct values for input 6 symbols" do
        symbols = { "X21" => 3, "X31" => 4 }
        parser_symbols_should_equal_symbols('input_6.txt', symbols)
      end
    end

    describe "input 7" do
      it "should return correct values for input 7 symbols" do
        symbols = { "X21" => 3, "X31" => 4 }
        parser_symbols_should_equal_symbols('input_7.txt', symbols)
      end
      describe "errors" do
        it "should be blank" do
          parser = AddressParser.new(Linker.new(FIXTURES + 'input_7.txt'))
          parser.parse
          parser.errors.should be_empty
        end
      end
    end

    describe "input 8" do
      it "should return correct values for input 8 symbols" do
        parser = AddressParser.new(Linker.new(FIXTURES + 'input_8.txt'))
        parser.parse
        parser.symbols.should be_empty
      end
    end
    
  end
  
  describe "modules" do
    describe "input 1.txt" do
      before(:each) do
        @parser = AddressParser.new(Linker.new(FIXTURES + 'input_1.txt'))
        @parser.parse
      end
      it "should return 4 modules" do
        @parser.modules.length.should == 4
      end
      it "should set correct module addrs" do
        parser_base_addresses_should_equal(@parser, [5,11,13,16])
      end
    end
    describe "input 2.txt" do
      before(:each) do
        @parser = AddressParser.new(Linker.new(FIXTURES + 'input_2.txt'))
        @parser.parse
        @addrs = [5,11,13,16]
      end
      it "should return 4 modules" do
        @parser.modules.length.should == @addrs.length
      end
      it "should set correct module addrs" do
        parser_base_addresses_should_equal(@parser, @addrs)
      end
    end
    describe "input 3.txt" do
      before(:each) do
        @parser = AddressParser.new(Linker.new(FIXTURES + 'input_3.txt'))
        @parser.parse
        @addrs = [10, 18, 21, 27, 30, 36]
      end
      it "should return 4 modules" do
        @parser.modules.length.should == @addrs.length
      end
      it "should set correct module addrs" do
        parser_base_addresses_should_equal(@parser, @addrs)
      end
    end
    describe "input 4.txt" do
      before(:each) do
        @parser = AddressParser.new(Linker.new(FIXTURES + 'input_4.txt'))
        @parser.parse
        @addrs = [3, 4, 5]
      end
      it "should return 4 modules" do
        @parser.modules.length.should == @addrs.length
      end
      it "should set correct module addrs" do
        parser_base_addresses_should_equal(@parser, @addrs)
      end
    end
  end
  
end
