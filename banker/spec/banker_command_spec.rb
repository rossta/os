require File.dirname(__FILE__) + '/spec_helper'

describe BankerCommand do
  before(:each) do
    Logger.debug true
  end
  
  after(:each) do
    Logger.debug false
  end
  
  describe "joint" do
    [1,2,3,4,5,6,7,8,9,10,11,12,13].each do |num|
      it "should process input file #{num}" do
        Logger.info "---Input #{num}---"
        command = BankerCommand.new
        command.run(FIXTURES + "input_#{num}.txt")
        Logger.info ""
        result    = command.to_s.gsub(/[ \n]+/, " ")
        expected  = File.open(FIXTURES + "joint/output_#{num}.txt").read.strip.gsub(/[ \n]+/, " ")
        result.should == expected
      end
    end
  end
  describe "banker" do
    describe "run" do
      [1,2,3,4,5,6,7,8,9,10,11,12,13].each do |num|
        it "should process input file #{num}" do
          Logger.info "---Input #{num}---"
          command = BankerCommand.new
          command.run_banker(FIXTURES + "input_#{num}.txt")
          Logger.info ""
          result    = command.to_s.gsub(/[ \n]+/, " ")
          expected  = File.open(FIXTURES + "banker/output_#{num}.txt").read.strip.gsub(/[ \n]+/, " ")
          result.should == expected
        end
      end
    end
  end
  describe "optimist" do
    describe "run" do
      [1,2,3,4,5,6,7,8,9,10,11,12,13].each do |num|
        it "should process input file #{num}" do
          Logger.info "---Input #{num}---"
          command = BankerCommand.new
          command.run_optimist(FIXTURES + "input_#{num}.txt")
          Logger.info ""
          result    = command.to_s.gsub(/[ \n]+/, " ")
          expected  = File.open(FIXTURES + "optimist/output_#{num}.txt").read.strip.gsub(/[ \n]+/, " ")
          result.should == expected
        end
      end
    end
  end
end
