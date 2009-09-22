class Instruction
  attr_accessor :type, :address, :op_code, :word
  
  def initialize(type, word)
    @type = type
    @address = word % 1000
    @op_code = (word - @address) / 1000
  end
  
  def update_address(opts = {})
    case type
    when InstructionType::R then 
      validate_and_update_relative_address(opts[:base_address], opts[:size])
    when InstructionType::E then
      validate_and_update_external_address(opts[:symbol])
    end
    
    validate_machine_size unless type == InstructionType::I
  end
  
  def to_s
    text = word.to_s
    text += " " + errors.join(" ") if errors.any?
    text
  end
  
  def word
    (op_code * 1000) + address
  end
  
  def errors
    @errors ||= []
  end
  
  def error_message
    errors.join(" ")
  end

protected

  def validate_machine_size
    if address > Machine::SIZE
      errors << "Error: Absolute address exceeds machine size; zero used."
      @address = 0
    end
  end
  
  def validate_and_update_relative_address(base_address, size)
    if address > size
      @address = 0
      errors << "Error: Relative address exceeds module size; zero used."
    else
      @address += base_address
    end
  end
  
  def validate_and_update_external_address(symbol)
    if addr = SymbolTable.address(symbol)
      @address = addr
    else
      @address = 0
      errors << "Error: #{symbol} is not defined; zero used."
    end
  end
  
end
