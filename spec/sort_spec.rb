$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'
include Algorithms

describe Algorithms::Sort do
  before(:each) do
    @sorts = %w(bubble_sort selection_sort heapsort insertion_sort shell_sort quicksort mergesort)
  end
    
  it "should work for empty containers" do
    empty_array = []
    @sorts.each { |sort| Sort.send(sort, empty_array).should eql([]) }
  end
  
  it "should work for a container of size 1" do
    one_array = [1]
    @sorts.each { |sort| Sort.send(sort, one_array).should eql(one_array) }
  end
    
  it "should work for random arrays of numbers" do
    n = 500
    rand_array = Array.new(n) { rand(n) }
    sorted_array = rand_array.sort
    
    @sorts.each { |sort| Sort.send(sort, rand_array.dup).should eql(sorted_array) }
  end    
  
end