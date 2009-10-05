class ProcessParser
  include Parsing
  attr_reader :reader
  
  def initialize(reader = nil)
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
  
  def processes
    @processes ||= []
  end

protected

  def original_input
    text = [processes.size]
    text += processes.map { |p| p.to_s }
    text.join(" ")
  end
  
end