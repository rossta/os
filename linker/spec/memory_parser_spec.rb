require File.dirname(__FILE__) + '/spec_helper'

# describe MemoryParser do
#   describe "initialize" do
#     it "should set the reader" do
#       MemoryParser.new(:linker).linker.should == :linker
#     end
#   end
# 
#   describe "memory_map" do
#     describe "input 1" do
#       before(:each) do
#         linker = Linker.new(FIXTURES + 'input_1.txt')
#         4.times { |i| linker.memory_map << ProgramModule.new }
#         @parser = MemoryParser.new(linker)
#         @parser.parse
#         @first_module = linker.memory_map[0]
#         @second_module = linker.memory_map[1]
#       end
#       describe "uses" do
#         it "should return 2 uses for first module" do
#           @first_module.uses.size.should == 2
#         end
#         it "should return uses ['z', 'xy'] for first module" do
#           @first_module.uses.should == ["z", "xy"]
#         end
#         it "should return 1 uses for second module" do
#           @second_module.uses.size.should == 1
#         end
#         it "should return uses ['z'] for second module" do
#           @second_module.uses.should == ["z"]
#         end
#       end
#       describe "instructions" do
#         it "should have size 5 for first module" do
#           @first_module.size.should == 5
#         end
#         it "should set correct instruction type first module" do
#           %w[R I E R E].each_with_index do |type, i|
#             instruction = @first_module.instructions[i]
#             instruction.type.should == type
#           end
#         end
#         it "should set correct address first module" do
#           %w[1004 5678 2000 8002 7001].each_with_index do |addr, i|
#             pending
#             instruction = @first_module.instructions[i]
#             word = instruction.word
#             word.should == addr
#           end
#         end
#         it "should have size 6 for second module" do
#           @first_module.size.should == 5
#         end
#         it "should set correct instruction type second module" do
#           %w[R E E E R A].each_with_index do |type, i|
#             instruction = @second_module.instructions[i]
#             instruction.type.should == type
#           end
#         end
#         it "should set correct address first module" do
#           %w[8001 1000 1000 3000 1002 1010].each_with_index do |addr, i|
#             instruction = @second_module.instructions[i]
#             instruction.word.should == addr
#           end
#         end
#       end
#     end
#     # describe "errors" do
#     #   describe "input 4" do
#     #     it "should validate address < MACHINE_SIZE" do
#     #       error_module = ProgramModule.new(1)
#     #       memory_map = [ProgramModule.new, error_module, ProgramModule.new]
#     #       parser = MemoryParser.new(Reader.new(FIXTURES + 'input_4.txt'), {}, memory_map)
#     #       parser.parse
#     #     
#     #       error_module.instructions[0].error_message.should == "Absolute address exceeds machine size; zero used."
#     #     end
#     #   end
#     #   describe "input 5" do
#     #     it "should validate X21 not defined" do
#     #       error_module = ProgramModule.new(1)
#     #       memory_map = [error_module, ProgramModule.new, ProgramModule.new]
#     #       parser = MemoryParser.new(Reader.new(FIXTURES + 'input_5.txt'), { "X31" => 4 }, memory_map)
#     #       parser.parse
#     # 
#     #       error_module.instructions[0].error_message.should == "X21 is not defined; zero used."
#     #     end
#     #     it "should validate address < MACHINE_SIZE" do
#     #       error_module = ProgramModule.new(1)
#     #       memory_map = [ProgramModule.new, error_module, ProgramModule.new]
#     #       parser = MemoryParser.new(Reader.new(FIXTURES + 'input_5.txt'), {}, memory_map)
#     #       parser.parse
#     #     
#     #       error_module.instructions[0].error_message.should == "Absolute address exceeds machine size; zero used."
#     #     end
#     #   end
#     # end
#     
#   end
# end
