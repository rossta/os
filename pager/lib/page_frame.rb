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
    @page = page
    @page.load!
  end
  
end
