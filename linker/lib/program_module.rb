class ProgramModule
  attr_reader :base_address
  
  def initialize(base_address = 0)
    @base_address = base_address
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
  
  def errors
    @errors ||= {}
  end
  
  def create_instruction(type, address)
    instruction = Instruction.new(type, address)
    instructions << instruction
    instruction
  end
  
  def to_s
    text = instructions.map do |inst|
      "#{base_address + instructions.index(inst)}:  " + inst.to_s
    end
    text.join("\n") + "\n"
  end
  
  class Instruction
    attr_accessor :type, :address, :op_code
    def initialize(type, word)
      @type = type
      @op_code = word.slice(0, 1).to_i
      @address = word.slice(1, 3).to_i
    end
    
    def word
      "#{op_code}#{format("%03d", address)}"
    end
    
    def to_s
      text = word
      text += " " + errors.join(" ") if errors.any?
      text
    end
    
    def errors
      @errors ||= []
    end
    
    def error_message
      errors.join(" ")
    end
  end
end