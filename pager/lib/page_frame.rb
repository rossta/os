class PageFrame
  attr_reader :index
  def initialize(index)
    @index = index
    @page  = nil
  end
  
  def free?
    @page.nil?
  end
end
