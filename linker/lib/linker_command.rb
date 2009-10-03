class LinkerCommand
  def run(arguments)
    linker = Linker.new(arguments.first)
    linker.link
    puts linker.to_s
  end
end