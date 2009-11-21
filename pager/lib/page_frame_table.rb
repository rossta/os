class PageFrameTable
  attr_reader :frames
  def initialize(size)
    @size = size
    @frames = Array.new(@size) { |i| PageFrame.new(i) }
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
    frame = frames.first
    load_frame(frame, page)
  end
  
  def load_frame(frame, page)
    frame.load_page(page)
    frame
  end

  def find_page_evict_frame
    return nil if free_frame?
    frames.first
  end

  private

end
