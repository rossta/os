class ProgramModule
  attr_accessor :base_address, :symbols
  
  def initialize(base_address = 0)
    @base_address = base_address
  end
  
  def symbols
    @symbols ||= {}
  end
  
  def uses
    @uses ||= []
  end
  
  def instructions
    @instructions ||= []
  end
  
  def size
    instructions.size
  end
  
  def map
    instructions.each do |instr|
      type = instr.type
      case type
      when InstructionType::R then instr.address += base_address
      when InstructionType::E then instr.address = SymbolTable.table[uses[instr.address]]
      end
    end
  end
  
  def defines?(symbol)
    symbols.keys.include?(symbol)
  end
  
  def errors
    @errors ||= {}
  end
  
  def create_instruction(type, address)
    instruction = Instruction.new(type, address)
    instructions << instruction
    instruction
  end
  
  def to_s
    text = instructions.map do |instr|
      index = base_address + instructions.index(instr)
      t = index.to_s
      t += (index > 9) ? ": " : ":  "
      t += instr.to_s
    end
    text.join("\n")
  end
  
end