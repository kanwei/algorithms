$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Containers

require 'rubygems'
require 'rbench'

RBench.run(2) do
  trees = %w(hash rbtree splaytree)
  trees.each { |tree| send(:column, tree.intern) }

  rbtree = RBTreeMap.new
  splaytree = SplayTreeMap.new
  hash = {}

  random_array = Array.new(300_000) { |i| rand(i) }

  report 'Insertion' do
    rbtree { random_array.each_with_index { |x, index| rbtree[index] = x } }
    splaytree { random_array.each_with_index { |x, index| splaytree[index] = x } }
    hash { random_array.each_with_index { |x, index| hash[index] = x } }
  end

  report 'key? (linear order)' do
    rbtree { random_array.each { |n| rbtree.key?(n) } }
    splaytree { random_array.each { |n| splaytree.key?(n) } }
    hash { random_array.each { |n| hash.key?(n) } }
  end

  report 'Lookup in sorted order' do
    rbtree { rbtree.each { |k, _v| k } }
    splaytree { splaytree.each { |k, _v| k } }
    hash { hash.sort.each { |k, _v| k } }

    # a1, a2, a3 = [], [], []
    # rbtree.each { |k, v| a1 << k }
    # splaytree.each { |k, v| a2 << k }
    # hash.sort.each { |k, v| a3 << k }
    #
    # puts "Lookup correct" if a1 == a2 && a1 == a3
  end

  report 'Random lookups in a smaller subset' do
    select_subset = random_array[0..random_array.size / 20] # 5%
    size = select_subset.size
    rbtree { 10_000.times { rbtree[select_subset[rand(size)]] } }
    splaytree { 10_000.times { splaytree[select_subset[rand(size)]] } }
    hash { 10_000.times { hash[select_subset[rand(size)]] } }
  end
end
