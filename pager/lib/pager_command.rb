class PagerCommand
  attr_accessor :report

  def run(arguments)
    to_s
  end

  def create_report(pager)
    PagerReport.new(pager)
  end
    
  def to_s
    report.to_s
  end
  
end