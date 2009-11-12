class PagerCommand
  attr_accessor :report

  def run(arguments)
    if arguments.is_a?(Array)
      file_name = arguments.first
      Logger.debug(arguments.last == "-v" || arguments.last == "--verbose")
    else
      file_name = arguments
      Logger.debug(false)
    end
    to_s
  end
  
  def create_report(manager)
    PagerReport.new(manager)
  end
    
  def to_s
    report.to_s
  end
  
end