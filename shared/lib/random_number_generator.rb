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
    num = number
    (num.to_f / DENOMINATOR * 10).to_i / 10.0
  end

  def initialize
    @reader = Reader.new(Configuration.random_numbers_file)
  end

  def number
    num = @reader.readline.strip.to_i
    notify_observers(num)
    num
  end

  def notify_observers(num)
    observers.each { |o| o.random_number_used(num) }
  end
  
  def register(observer)
    observers << observer
  end
  
  def observers
    @observers ||= []
  end

end