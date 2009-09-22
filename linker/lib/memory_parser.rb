require File.dirname(__FILE__) + '/parser'

class MemoryParser < Parser

  def parse
    @char = reader.next
    MemoryMap.memory.modules.each do |program_module|
      detect_uses(program_module)
      detect_instructions(program_module)
    end
    reader.file.rewind
  end
  
private
  def detect_uses(program_module)
    skip_symbols
    parse_number.times do |i|
      program_module.uses << parse_word
    end
  end
  
  def detect_instructions(program_module)
    parse_number.times do |i|
      type = parse_word
      word = parse_number
      
      program_module.create_instruction(type, word)
    end
    program_module.map_instructions
  end
  
  def skip_symbols
    parse_number.times do |i| 
      parse_word
      parse_number
    end
  end
  
end