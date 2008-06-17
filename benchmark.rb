require 'lib/algorithms'
require 'benchmark'
include Benchmark

# Benchmark heap
@random_array = []
@num_items = 10000
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
@tree = Containers::TreeMap.new
@ctree = Containers::CTreeMap.new
@hash = Hash.new

benchmark do |bench|
  bench.report("Tree: \t") do
    @random_array.each { |x| @tree[x] = x }
  end
  
  bench.report("CTree: \t") do
    @random_array.each { |x| @ctree[x] = x }
  end
  
  bench.report("Hash: \t") do
    @hash.each { |x| @hash[x] = x }
  end
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