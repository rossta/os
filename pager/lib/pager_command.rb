class PagerCommand
  attr_accessor :report

  def run(arguments)
    simulator = Paging::Simulator.new(arguments)
    to_s
  end

  def create_report(pager)
    self.report = Paging::Report.new(pager)
  end
    
  def to_s
    report.to_s
  end
  
end