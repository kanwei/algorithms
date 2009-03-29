$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Algorithms

require 'rubygems'
require 'rbench'

RBench.run(10) do
  trees = %w(hash rbtree splaytree)
  trees.each { |tree| self.send(:column, tree.intern) }
  
  rbtree = Containers::RBTreeMap.new
  splaytree = Containers::SplayTreeMap.new
  hash = Hash.new
  
  random_array = Array.new(10000) { |i| rand(i) }
  num = 1000
  
  report "Insertion" do
    rbtree { random_array.each_with_index  { |x,index| rbtree[index] = x } }
    splaytree { random_array.each_with_index  { |x,index| splaytree[index] = x } }
    hash { random_array.each_with_index  { |x,index| hash[index] = x } }
  end
  
  report "has_key?" do
    rbtree { num.times { |n| rbtree.has_key?(n) } }
    splaytree { num.times { |n| splaytree.has_key?(n) } }
    hash { num.times { |n| hash.has_key?(n) } }
  end
  
  report "Lookup in sorted order" do
    rbtree { rbtree.each { |k, v| k } }
    splaytree { splaytree.each { |k, v| k } }
    hash { hash.sort.each { |k, v| k } }
  end
end
