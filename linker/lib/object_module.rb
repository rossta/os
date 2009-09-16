class ObjectModule
  attr_reader :base_address
  
  def initialize(base_address)
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
  
  class Instruction
    attr_accessor :type, :address
    def initialize(type, address)
      @type = type
      @address = address
    end
  end
end