require File.dirname(__FILE__) + '/spec_helper'

describe PagerRunner do
  
  describe "arguments_valid?" do
    # M, the machine size in words. 
    # P, the page size in words. 
    # S, the size of a processes, i.e., the references are to virtual addresses 0..S-1. 
    # J, the ‘‘job mix’’, which determines A, B, and C, as described below. 
    # N, the number of references for each process. 
    # R, the replacement algorithm, LIFO (NO T FIFO), RANDOM, or LRU.
    it "should be true if 6 command line arguments: 5 integers, 1 string" do
      runner = PagerRunner.new(["800", "40", "400", "4", "5000", "lru", "0"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_true
    end
    it "should be true if 7th optional debug argumend given" do
      runner = PagerRunner.new(["800", "40", "400", "4", "5000", "lru", "0"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_true
    end
    it "should be false if missing arguments" do
      runner = PagerRunner.new(["800", "40", "400", "4", "5000"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_false
    end
    it "should be false if strings given for integers" do
      runner = PagerRunner.new(["foo", "bar", "400", "4", "5000", "lru", "0"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_false
    end
    it "should be false if replacement algorithm not valid" do
      runner = PagerRunner.new(["800", "40", "400", "4", "5000", "foobar", "0"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_false
    end
    it "should be true if replacement algorithm if valid upcase" do
      runner = PagerRunner.new(["foo", "bar", "400", "4", "5000", "LRU", "0"], mock(PagerCommand))
      runner.send(:arguments_valid?).should be_false
    end
  end
end
