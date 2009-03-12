# :nodoc: all
$: << File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'algorithms'

require 'benchmark'
include Benchmark

# Benchmark heap
@random_array = []
@num_items = 10000
@num_items.times { |x| @random_array << rand(@num_items).to_s }
# @heap = Containers::MaxHeap.new(@random_array)
# 
# benchmark do |bench|
#   bench.report("Array#max:\t ") do
#     @num_items.times { @random_array.delete_at(@random_array.index(@random_array.max)) }
#   end
#   bench.report("MaxHeap:\t ") do
#     @num_items.times { @heap.max! }
#   end
# end

# Benchmark Deque
deque = Containers::Deque.new
array = []
benchmark do |bench|
  bench.report("Array:\t ") { 1000000.times  { |x| array << x } }
  bench.report("Deque:\t ") { 1000000.times  { |x| deque.push_back(x) } }
end

# Benchmark Search trees
@rb_tree = Containers::RBTreeMap.new
@splay_tree = Containers::SplayTreeMap.new
@hash = Hash.new

benchmark do |bench|
  puts "\nInsertion"
  bench.report("RBTree: \t")    { @random_array.each_with_index  { |x,index| @rb_tree[index] = x } }
  bench.report("SplayTree: \t") { @random_array.each_with_index  { |x,index| @splay_tree[index] = x } }
  bench.report("Hash: \t\t")    { @random_array.each_with_index  { |x,index| @hash[index] = x } }
  
  puts "\nTest has_key?" 
  bench.report("RBTree: \t")    { @num_items.times { |n| @rb_tree.has_key?(n) } }
  bench.report("SplayTree: \t") { @num_items.times { |n| @splay_tree.has_key?(n) } }
  bench.report("Hash: \t\t")    { @num_items.times { |n| @hash.has_key?(n) } }
  
  puts "\nSorted order" 
  bench.report("RBTree: \t")    { @rb_tree.each { |k, v| k } }
  bench.report("SplayTree: \t") { @splay_tree.each { |k, v| k } }
  bench.report("Hash: \t\t")    { @hash.sort.each { |k, v| k } }
end