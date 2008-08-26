$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'
class Array; include Algorithms::Sort; end # Add the sorting functions to arrays
class Containers::RBTreeMap; include Algorithms::Sort; end # Add the sorting functions to RBTreeMaps

describe Algorithms::Sort do
  before(:each) do
    @sorts = %w(bubble_sort selection_sort heapsort insertion_sort shell_sort quicksort mergesort)
  end
    
  it "should work for empty containers" do
    empty_array = []
    @sorts.each { |sort| empty_array.send(sort).should eql([]) }
  end
  
  it "should work for a container of size 1" do
    one_array = ["Just One"]
    @sorts.each { |sort| one_array.send(sort).should eql(one_array) }
  end
    
  it "should work for random arrays" do
    n = 1000
    rand_array = Array.new(n) { rand(n) }
    sorted_array = rand_array.sort
    
    @sorts.each { |sort| rand_array.send(sort).should eql(sorted_array) }
  end
  
  it "should work for RBTreeMaps" do
    n = 1000
    rand_array = Array.new(n) { rand(n) }
    sorted_array = rand_array.sort
    
    treemap = Containers::RBTreeMap.new
    rand_array.each { |n| treemap.push(n, n) }
    
    @sorts.each { |sort| treemap.send(sort).should eql(sorted_array) }
  end
    
  
end