class Logger
  def self.info(text)
    return unless debug?
    puts text 
  end
  
  def self.record(text)
    recorder << text
  end
  
  def self.debug?
    @@debug ||= false
  end
  
  def self.debug(debug)
    @@debug = debug
  end
  
  def self.recorder
    @@recorder ||= []
  end
end