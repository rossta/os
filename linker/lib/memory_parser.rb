require File.dirname(__FILE__) + '/parser'

class MemoryParser < Parser

  def parse
    @char = reader.next
    MemoryMap.instance.modules.each do |program_module|
      detect_uses(program_module)
      detect_instructions(program_module)
    end
    reader.file.rewind
    
    MemoryMap.validate!
  end
  
private
  def detect_uses(program_module)
    skip_symbols
    parse_number.times do |i|             # Start of the use list, parse_number is NU
      program_module.uses << parse_word   # External symbols, parse_number is X21, X31, etc.
    end
  end
  
  def detect_instructions(program_module)
    parse_number.times do |i|             # Start of instr set, parse_number is NT
      type = parse_word                   # Instruction type, parse_word is I, R, E, or A
      word = parse_number                 # Instr, parse_number is Opcode + Address
      
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