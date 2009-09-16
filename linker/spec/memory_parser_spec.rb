require File.dirname(__FILE__) + '/spec_helper'

describe MemoryParser do
  describe "initialize" do
    it "should set the reader" do
      MemoryParser.new(:reader, :symbols, :modules).reader.should == :reader
    end
    it "should return symbols" do
      MemoryParser.new(:reader, :symbols, :modules).symbols.should == :symbols
    end
    it "should return modules" do
      MemoryParser.new(:reader, :symbols, :modules).modules.should == :modules
    end
  end

  describe "modules" do
    describe "input 1" do
      before(:each) do
        @modules = [
          ObjectModule.new(0),
          ObjectModule.new(5),
          ObjectModule.new(11),
          ObjectModule.new(13)
        ]
        @parser = MemoryParser.new(Reader.new(FIXTURES + 'input_1.txt'), {}, @modules)
        @parser.parse
        @first_module = @parser.modules[0]
        @second_module = @parser.modules[1]
      end
      describe "uses" do
        it "should return 2 uses for first module" do
          @first_module.uses.size.should == 2
        end
        it "should return uses ['z', 'xy'] for first module" do
          @first_module.uses.should == ["z", "xy"]
        end
        it "should return 1 uses for second module" do
          @second_module.uses.size.should == 1
        end
        it "should return uses ['z'] for second module" do
          @second_module.uses.should == ["z"]
        end
      end
      describe "instructions" do
        it "should have size 5 for first module" do
          @first_module.size.should == 5
        end
        it "should set correct instruction type first module" do
          %w[R I E R E].each_with_index do |type, i|
            instruction = @first_module.instructions[i]
            instruction.type.should == type
          end
        end
        it "should set correct address first module" do
          [1004, 5678, 2000, 8002, 7001].each_with_index do |addr, i|
            instruction = @first_module.instructions[i]
            instruction.address.should == addr
          end
        end
        it "should have size 6 for second module" do
          @first_module.size.should == 5
        end
        it "should set correct instruction type second module" do
          %w[R E E E R A].each_with_index do |type, i|
            instruction = @second_module.instructions[i]
            instruction.type.should == type
          end
        end
        it "should set correct address first module" do
          [8001,1000,1000,3000,1002,1010].each_with_index do |addr, i|
            instruction = @second_module.instructions[i]
            instruction.address.should == addr
          end
        end
      end
    end
  end
end
