class PagerCommand
  attr_accessor :report

  def run(arguments)
    simulator = Paging::Simulator.new(arguments)
    self.report = create_report(simulator)
    report.to_s
  end

  def create_report(simulator)
    self.report = Paging::Report.new(simulator)
  end
  
end