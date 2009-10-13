require File.dirname(__FILE__) + '/spec_helper'

describe SchedulerCommand do
  describe "run" do
    describe "FIFO" do
      [1,2,3,4,5,6,7].each do |num|
        it "should process input file #{num}" do
          command_report_should_match_output_file(num)
        end
      end
    end
    describe "RR" do
      [1,2,3].each do |num|
        it "should process input file #{num}" do
          command_report_should_match_output_file(num, "rr")
        end
      end
      [4].each do |num|
        it "should process input file #{num}" do
          command_report_should_match_output_file(num, "rr")
        end
      end
    end
  end
  
  describe "details" do
    [3,4].each do |num|
      it "should process input file #{num}" do
        pending
        command = simulate_command(num, "rr")
        File.open(FIXTURES + "rr/cycles/output_#{num}.txt").readlines.each_with_index do |line, i|
          
          state = command.states.shift
          if !line.nil? && !state.nil?
            line = line.gsub(/^.*:/, "").gsub(/\.$/, "").gsub(/ /, "").gsub(/\d+/, "").chomp
            state = state.gsub(/ /, "").gsub(/\d+/, "")
            # puts i
            state.should == line
          end
        end
      end
    end
  end
end

def command_report_should_match_output_file(index, strategy = "fifo")
  command = simulate_command(index, strategy)
  command.report_display.should == File.open(FIXTURES + "#{strategy}/output_#{index}.txt").read.strip
end

def command_states_should_match_output_file(index, strategy = "fifo")
  simulate_command(index, strategy).details.should == File.open(FIXTURES + "#{strategy}/cycles/output_#{index}.txt").read.strip
end

def simulate_command(index, strategy)
  command = SchedulerCommand.new
  command.simulate([FIXTURES + "input_#{index}.txt", strategy])
  command
end
