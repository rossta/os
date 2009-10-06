module Scheduling
  class OS
  
    def random_os(interval)
      1 + (generator.number % interval)
    end
  
  protected
    def generator
      @generator ||= RandomNumberGenerator.new
    end
  end
end
