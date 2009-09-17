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
  
  class Instruction
    attr_accessor :type, :address, :word
    def initialize(type, word)
      @type = type
      @word = word
    end
    
    def address
      @address ||= word.slice(1, 3).to_i
    end
    
    def errors
      @errors ||= []
    end
    
    def error_message
      errors.join(". ")
    end
  end
end