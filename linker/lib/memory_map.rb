class MemoryMap
  
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
    
  end
  
  def to_s
    result = ["Memory Map"]
    @modules.each do |program_module|
      result << program_module.to_s
    end
    result.join("\n") + "\n"
  end
  
  def method_missing(sym, *args, &block)
    @modules.send sym, *args, &block
  end
  
end