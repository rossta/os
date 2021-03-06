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
  
  def map_instructions
    instructions.each do |instr|
      instr.update_address(:symbol => uses[instr.address], :base_address => base_address, :size => size)
    end
  end
  
  def defines?(symbol)
    symbols.keys.include?(symbol)
  end
  
  def errors
    @errors ||= {}
  end
  
  def create_instruction(type, address)
    instructions << Instruction.new(type, address)
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
  
  def unused_symbols
    return [] if !instructions.all? { |instr| instr.valid? }
    used_symbols = instructions.map { |instr| instr.type == InstructionType::E ? instr.symbol : nil }.compact
    unused_symbols = uses - used_symbols
    unused_symbols
  end
end