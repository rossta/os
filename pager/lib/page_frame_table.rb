class PageFrameTable
  attr_reader :frames, :replacement_strategy
  def initialize(size, &block)
    @size = size
    @frames = Array.new(@size) { |i| PageFrame.new(i) }
    @replacement_strategy = block
  end

  def free_frame
    frames.detect { |f| f.free? }
  end

  def free_frame?
    !free_frame.nil?
  end

  def find_frame(page)
    frames.detect { |f| f.page == page }
  end

  def load_new_frame(page)
    frame = frames.reverse.detect { |f| f.free? }
    load_frame(frame, page)
  end
  
  def load_frame(frame, page)
    frame.load_page(page)
    frame
  end

  def find_eviction_frame
    return nil if free_frame?
    replacement_strategy.call frames
  end

end
