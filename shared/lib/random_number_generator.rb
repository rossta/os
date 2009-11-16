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
  
  def initialize
    @reader = Reader.new(Configuration.random_numbers_file)
  end
  
  def number
    number = @reader.readline.strip.to_i
    number
  end
  
end