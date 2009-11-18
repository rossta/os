class PageFrameTable
  attr_reader :frames
  def initialize(size)
    @size = size
    @frames = Array.new(@size) { |i| PageFrame.new(i) }
  end
  
  def free_frame
    frames.detect { |f| f.free? }
  end
  
  def select_frame(word)
    frame = frames.first
    
  end
  
end
