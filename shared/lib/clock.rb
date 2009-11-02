class Clock
  def initialize
    @cycles = 0
    @io_cycles = 0
  end

  def cycle
    @cycles += 1
  end

  def cycle_io
    @io_cycles += 1
  end

  def time
    @cycles
  end

  def io_time
    @io_cycles
  end

  def self.start
    @@instance = new
  end

  def self.instance
    @@instance ||= new
  end

  def self.time
    instance.time
  end

  def self.io_time
    instance.io_time
  end

  def self.cycle
    instance.cycle
  end

  def self.cycle_io
    instance.cycle_io
  end

end
