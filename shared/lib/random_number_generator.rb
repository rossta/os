class RandomNumberGenerator

  def self.number
    instance.number
  end

  def self.clear!
    @@instance = RandomNumberGenerator.new
  end

  def self.instance
    @@instance ||= RandomNumberGenerator.new
  end
  
  def self.register_observer(observer)
    instance.register(observer)
  end

  DENOMINATOR = 2147483648
  def self.quotient
    ("%0.1f" % (number / DENOMINATOR.to_f)).to_f
  end

  def initialize
    @reader = Reader.new(Configuration.random_numbers_file)
  end

  def number
    number = @reader.readline.strip.to_i
    notify_observers(number)
    number
  end

  def notify_observers(number)
    observers.each { |o| o.random_number_used(number) }
  end
  
  def register(observer)
    observers << observer
  end
  
  def observers
    @observers ||= []
  end

end