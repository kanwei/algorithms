require 'lib/algorithms'
require 'benchmark'
include Benchmark

# Benchmark heap
@random_array = []
@num_items = 100000
@num_items.times { |x| @random_array << rand(@num_items) }
# @heap = DS::MaxHeap.new(@random_array)

# benchmark do |bench|
#   bench.report("Array#max:\t ") do
#     @num_items.times { @random_array.delete_at(@random_array.index(@random_array.max)) }
#   end
#   bench.report("MaxHeap:\t ") do
#     @num_items.times { @heap.get_max! }
#   end
# end

# Benchmark Search trees
@tree = DS::RedBlackTree.new
@ctree = CRedBlackTree.new
@random_array.each { |x| @tree.put(x, x); @ctree.put(x, x) }

benchmark do |bench|
  # bench.report("#find: \t") do
  #   @num_items.times { |n| @random_array.include?(n) }
  # end
  
  bench.report("Tree: \t") do
    @num_items.times { |n| @tree.contains?(n) }
  end
  
  bench.report("CTree: \t") do
    @num_items.times { |n| @ctree.contains?(n) }
  end
end