$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Containers

require 'rubygems'
require 'rbench'

RBench.run(2) do
  trees = %w(hash rbtree splaytree)
  trees.each { |tree| self.send(:column, tree.intern) }
  
  rbtree = RBTreeMap.new
  splaytree = SplayTreeMap.new
  hash = Hash.new
  
  random_array = Array.new(300000) { |i| rand(i) }
  
  report "Insertion" do
    rbtree { random_array.each_with_index  { |x,index| rbtree[index] = x } }
    splaytree { random_array.each_with_index  { |x,index| splaytree[index] = x } }
    hash { random_array.each_with_index  { |x,index| hash[index] = x } }
  end
  
  report "has_key? (linear order)" do
    rbtree { random_array.each { |n| rbtree.has_key?(n) } }
    splaytree { random_array.each { |n| splaytree.has_key?(n) } }
    hash { random_array.each { |n| hash.has_key?(n) } }
  end
  
  report "Lookup in sorted order" do
    rbtree { rbtree.each { |k, v| k } }
    splaytree { splaytree.each { |k, v| k } }
    hash { hash.sort.each { |k, v| k } }
    
    # a1, a2, a3 = [], [], []
    # rbtree.each { |k, v| a1 << k }
    # splaytree.each { |k, v| a2 << k }
    # hash.sort.each { |k, v| a3 << k }
    # 
    # puts "Lookup correct" if a1 == a2 && a1 == a3
  end
  
  report "Random lookups in a smaller subset" do
    select_subset = random_array[0..random_array.size/20] # 5%
    size = select_subset.size
    rbtree { 10000.times { rbtree[ select_subset[rand(size)] ] } }
    splaytree { 10000.times { splaytree[ select_subset[rand(size)] ] } }
    hash { 10000.times { hash[ select_subset[rand(size)] ] } }
  end
  
end
