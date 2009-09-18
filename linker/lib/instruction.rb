class Instruction
  attr_accessor :type, :address, :op_code, :word
  
  def initialize(type, word)
    @type = type
    @address = word % 1000
    @op_code = (word - address) / 1000
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
  
  def validate!
    if address > Machine::SIZE && type != InstructionType::I
      errors << "Error: Absolute address exceeds machine size; zero used."
      @address = 0
    end
  end
  
  def error_message
    errors.join(" ")
  end
end
