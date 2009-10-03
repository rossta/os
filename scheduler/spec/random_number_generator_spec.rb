require File.dirname(__FILE__) + '/spec_helper'

describe RandomNumberGenerator do
  before(:each) do
    @numbers = [123, 456, 789]
    @reader = mock(Reader, :readlines => ["123\n", "456\n", "789\n"], :line_count => @numbers.size)
    Reader.stub!(:new).and_return(@reader)
    @reader.stub!(:rewind).and_return(0)
  end
  
  describe "number" do
    it "should return random number from random_numbers config file" do
      generator = RandomNumberGenerator.new
      @numbers.should include(generator.number)
    end
  end
  
  describe "count" do
    it "should return line count of source file" do
      generator = RandomNumberGenerator.new
      generator.count.should == 3
    end
    it "should call rewind" do
      generator = RandomNumberGenerator.new
      @reader.should_receive(:line_count).and_return(3)
      generator.count
    end
  end
end
