require File.dirname(__FILE__) + '/spec_helper'

describe Reader do
  
  before do
    @file_name = FIXTURES + '__fixture__.txt'
    @file = create_basic_file(@file_name)
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
    
    describe "end of file reached" do
      before(:each) do
        File.open(FIXTURES + "_a_.txt", 'w') {|f| f.write("a") }
      end
      after(:each) do
        File.delete(FIXTURES + "_a_.txt")
      end
      it "should return nil" do
        r = Reader.new(FIXTURES + "_a_.txt")
        r.next
        
        r.next.should be_nil
      end
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