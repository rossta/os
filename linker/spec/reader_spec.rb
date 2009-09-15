require File.dirname(__FILE__) + '/spec_helper'

FIXTURES = File.dirname(__FILE__) + '/fixtures/'

describe Reader do
  
  before do
    @file_name = FIXTURES + '__fixture__.txt'
    File.open(@file_name, 'w') {|f| f.write("a.txt") }
    
    @file = File.open(@file_name, 'w+')
    @file.puts("1 xy 2\n")
    @file.puts("2 z xy\n")
    @file.puts("5 R 1004  I 5678  E 2000  R 8002  E 7001\n")
    @file.rewind
  end

  after do
    File.delete(@file_name)
  end

  describe "initialize" do
    
    it "should set file name" do
      r = Reader.new(@file_name)
      r.file.path.should == @file_name
    end
    
  end
  
  describe "next" do
    it "should return 1" do
      r = Reader.new(@file_name)
      r.next.should == "1"
    end
  end
  
  describe "method_missing" do
    describe "rewind" do
      it "should return 0" do
        r = Reader.new(@file_name)
        r.rewind.should == 0
      end
    end
  end
end