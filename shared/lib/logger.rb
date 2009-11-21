class Logger
  
  def self.init(arg)
    d = arg.slice(0..0).to_i
    v = arg.slice(1..1).to_i
    @@debug   = d != 0
    @@verbose = v != 0
    @@recorder = []
  end
  
  def self.info(text)
    return unless debug?
    puts text 
  end
  
  def self.record(text, verbose_only = false)
    return if verbose_only && !verbose?
    puts        text if spec?
    recorder << text
  end
  
  def self.debug?
    @@debug ||= false
  end

  def self.verbose?
    @@verbose ||= false
  end

  def self.verbose(verbose)
    @@verbose = verbose
  end
  
  def self.debug(debug)
    @@debug = debug
  end
  
  def self.spec(spec)
    @@spec = spec
  end
  
  def self.spec?
    @@spec ||= false
  end
  
  def self.recorder
    @@recorder ||= []
  end
end