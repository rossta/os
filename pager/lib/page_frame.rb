class PageFrame
  attr_accessor :page
  attr_reader :index
  def initialize(index)
    @index = index
  end
  
  def free?
    page.nil?
  end
  
  def page_number
    page.number
  end
  
  def process_number
    page.process.number
  end
  
  def evict_page!
    page.evict!
  end
  
  def load_page(page)
    self.page = page
    self.page.load!
  end
  
  def <=>(other)
    return -1 if self.page.reference < other.page.reference
    return 1  if self.page.reference > other.page.reference
    return 0
  end
end
