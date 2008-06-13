require 'lib/algorithms'
require 'benchmark'
include Benchmark

# Benchmark heap
@random_array = []
@num_items = 5000
@num_items.times { |x| @random_array << rand(@num_items) }
@heap = DS::MaxHeap.new(@random_array)

benchmark do |x|
  x.report("Array#max:\t ") do
    @num_items.times { @random_array.delete_at(@random_array.index(@random_array.max)) }
  end
  x.report("MaxHeap:\t ") do
    @num_items.times { @heap.get_max! }
  end
end