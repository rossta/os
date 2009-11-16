class PagerReport
  attr_reader :pager
  
  def initialize(pager)
    @pager = pager
  end
  
  def base_report
    text = []
    text << "The machine size is 20."
    text << "The page size is 10."
    text << "The process size is 10."
    text << "The job mix number is 2."
    text << "The number of references per process is 10."
    text << "The replacement algorithm is random."
    text << "The level of debugging output is 0"
    text.join("\n")
  end
end