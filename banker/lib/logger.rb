class Logger
  def self.info(text)
    puts text if debug?
  end
  
  def self.debug?
    @@debug = true
  end
  
  def self.debug(debug)
    @@debug = debug
  end
end