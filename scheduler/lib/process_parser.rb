class ProcessParser
  include Parsing
  attr_reader :reader

  def initialize(file_name = nil)
    @file_name = file_name
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
      processes << Scheduling::Process.new(a, b, c, io, processes.length)
    end
  end

  def processes
    @processes ||= []
  end
  
  def sorted_processes
    processes.sort { |a,b| a <=> b }
  end
  
  def to_s
    [original_input, sorted_input].join("\n")
  end
  
  def original_input
    "The original input was: #{processes_description(processes)}"
  end

  def sorted_input
    "The (sorted) input is:  #{processes_description(sorted_processes)}"
  end

protected

  def reader
    @reader ||= Reader.new(@file_name)
  end
  
  def processes_description(processes)
    text = [processes.size]
    text += processes.map { |p| p.to_s }
    text.join(" ")
  end

end