Dir.glob(File.join(File.dirname(__FILE__), './lib/*.rb')).each {|f| require f }

# Create and run the application
app = Runner.new(ARGV)
app.run
