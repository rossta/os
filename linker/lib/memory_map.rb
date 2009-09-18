class MemoryMap
  
  def self.memory
    @@memory ||= MemoryMap.new
  end
  
  attr_reader :modules
  
  def initialize
    @modules = []
  end
  
  def <<(object)
    @modules << object
  end
  
  def [](index)
    @modules[index]
  end
  
  def map
    @modules.each { |m| m.map }
  end
  
  def to_s
    result = ["Memory Map", "\n"]
    @modules.each do |program_module|
      result << program_module.to_s
    end
    result.join("")
  end
  
  def method_missing(sym, *args, &block)
    @modules.send sym, *args, &block
  end
  
end