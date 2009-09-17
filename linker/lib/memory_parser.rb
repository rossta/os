require File.dirname(__FILE__) + '/parser'

class MemoryParser < Parser

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
      word = parse_word
      
      instruction = object_module.create_instruction(type, word)
      if instruction.address > 600
        instruction.errors << "Absolute address exceeds machine size; zero used."
        instruction.address = 0
      end
    end
  end
  
  def skip_symbols
    parse_number.times do |i| 
      parse_word
      parse_number
    end
  end
  
end