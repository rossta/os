require File.dirname(__FILE__) + '/spec_helper'

describe PagerCommand do
  describe "base_report" do
    before(:each) do
      @command = PagerCommand.new
    end
    describe "input 1: 10 10 20 1 10 lru 0" do
      it "should produce expected base report" do
        input = %w|10 10 20 1 10 lru 0|
        @command.run(input)
        expected_output = <<-REPORT
The machine size is 10.
The page size is 10.
The process size is 20.
The job mix number is 1.
The number of references per process is 10.
The replacement algorithm is lru.
The level of debugging output is 0
        REPORT
        @command.report.base_report.should == expected_output.chomp
      end
    end
  end
  
  describe "debug report" do
    before(:each) do
      @command = PagerCommand.new
    end
    describe "input 1: 10 10 20 1 10 lru 0" do
      it "should produce expected debug report" do
        input = %w|10 10 20 1 10 lru 11|
        @command.run(input)
        expected_output = <<-REPORT
1 references word 11 (page 1) at time 1: Fault, using free frame 0.
1 uses random number: 1804289383
1 references word 12 (page 1) at time 2: Hit in frame 0.
1 uses random number: 846930886
1 references word 13 (page 1) at time 3: Hit in frame 0.
1 uses random number: 1681692777
1 references word 14 (page 1) at time 4: Hit in frame 0.
1 uses random number: 1714636915
1 references word 15 (page 1) at time 5: Hit in frame 0.
1 uses random number: 1957747793
1 references word 16 (page 1) at time 6: Hit in frame 0.
1 uses random number: 424238335
1 references word 17 (page 1) at time 7: Hit in frame 0.
1 uses random number: 719885386
1 references word 18 (page 1) at time 8: Hit in frame 0.
1 uses random number: 1649760492
1 references word 19 (page 1) at time 9: Hit in frame 0.
1 uses random number: 596516649
1 references word 0 (page 0) at time 10: Fault, evicting page 1 of 1 from frame 0.
1 uses random number: 1189641421
        REPORT
        @command.report.debug_report.gsub(/\n/, " ").should == expected_output.chomp.gsub(/\n/, " ")
      end
    end
  end
  
  describe "process_report" do
    before(:each) do
      @command = PagerCommand.new
    end
    it "should produce expected process report" do
      input = %w|10 10 20 1 10 lru 0|
      @command.run(input)
      expected_output = <<-REPORT
Process 1 had 2 faults and 9.0 average residency.

The total number of faults is 2 and the overall average residency is 9.0.
      REPORT
      @command.report.process_report.gsub(/\n/, " ").should == expected_output.chomp.gsub(/\n/, " ")
    end
  end
  
  describe "inputs" do
    before(:each) do
      # Logger.spec true
      
      @inputs = <<-INPUTS
10 10 20 1 10 lru 0
10 10 10 1 100 lru 0
10 10 10 2 10 lru 0
20 10 10 2 10 lru 0
20 10 10 2 10 random 0
20 10 10 2 10 lifo 0
20 10 10 3 10 lru 0
20 10 10 3 10 lifo 0
20 10 10 4 10 lru 0
20 10 10 4 10 random 0
90 10 40 4 100 lru 0
40 10 90 1 100 lru 0
40 10 90 1 100 lifo 0
800 40 400 4 5000 lru 0
10 5 30 4 3 random 0
      INPUTS
      @inputs = @inputs.split("\n")
    end
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].each do |num|
      it "should process input #{num}" do
        line = num - 1
        Logger.info "---Input #{num}---"
        Logger.info @inputs[line]
        Logger.info ""
        command = PagerCommand.new
        command.run(@inputs[line].split(" "))
        Logger.info ""
        result    = command.to_s.gsub(/[ \n\t]+/, " ")
        expected  = File.open(FIXTURES + "output_#{num}.txt").read.strip.gsub(/[ \n\t]+/, " ")
        result.should == expected
      end
    end
  end
end