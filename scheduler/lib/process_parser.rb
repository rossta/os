class ProcessParser
  include Parsing
  attr_accessor :reader
  
  def initialize(reader)
    @reader = reader
  end
  
  def parse
    reader.rewind
    @char = reader.next
    parse_number.times do |i|
      skip_symbol       # (
      a = parse_number
      b = parse_number
      c = parse_number
      io = parse_number
      skip_symbol       # )
      processes << Process.new(a, b, c, io)
    end
  end
  
  def original_input
    @original_input ||= normalize_input
  end
  
  def processes
    @processes ||= []
  end
  
protected
  
  def normalize_input
    reader.rewind
    input = reader.read
    input.match(/(.*\))/)[0]
  end
end