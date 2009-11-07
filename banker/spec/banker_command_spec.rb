require File.dirname(__FILE__) + '/spec_helper'

describe BankerCommand do
  describe "banker" do
    describe "run" do
      [1].each do |num|
        it "should process input file #{num}" do
          puts "---Input #{num}---"
          command   = simulate_command num
          puts ""
          result    = command.report.banker_report.to_s.gsub(/[ \n]+/, " ")
          expected  = File.open(FIXTURES + "banker/output_#{num}.txt").read.strip.gsub(/[ \n]+/, " ")
          result.should == expected
        end
      end
    end
  end
  # describe "optimist" do
  #   describe "run" do
  #     [1,2,3,4,5,6,7,8,9,10,11,12,13].each do |num|
  #       it "should process input file #{num}" do
  #         puts "---Input #{num}---"
  #         command   = simulate_command num
  #         puts ""
  #         result    = command.report.optimist_report.to_s.gsub(/[ \n]+/, " ")
  #         expected  = File.open(FIXTURES + "optimist/output_#{num}.txt").read.strip.gsub(/[ \n]+/, " ")
  #         result.should == expected
  #       end
  #     end
  #   end
  # end
end

def simulate_command(index)
  command = BankerCommand.new
  command.run(FIXTURES + "input_#{index}.txt")
end

