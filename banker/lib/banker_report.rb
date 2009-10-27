class BankerReport
  attr_reader :banker
  def initialize(optimist, banker)
  end
  
  def to_s
    text = [header]
    text << "Task 1"
    text.join("\n")
  end
  
  def header
    header = format("%-32s", "FIFO")
    header += "BANKER"
  end
  
end
