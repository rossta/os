require File.dirname(__FILE__) + '/parsing'

class MemoryParser
  include Parsing
  
  attr_accessor :reader, :symbols, :modules
  
  def initialize(reader, symbols, modules)
    @reader = reader
    @symbols = symbols
    @modules = modules
  end
  
  def parse
    while(@char = reader.next)
      modules.each do |object_module|
        detect_uses(object_module)
        detect_instructions(object_module)
      end
    end
  end
  
private
  def detect_uses(object_module)
    skip_symbols
    parse_number.times do |i|
      object_module.uses << parse_word
    end
  end
  
  def detect_instructions(object_module)
    parse_number.times do |i|
      type = parse_word
      address = parse_number
      object_module.instructions << ObjectModule::Instruction.new(type, address) 
    end
  end
  
  def skip_symbols
    parse_number.times do |i| 
      parse_word
      parse_number
    end
  end
  
end