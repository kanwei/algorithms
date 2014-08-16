$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'
include Algorithms

describe "sort algorithms" do
  before(:each) do
    @sorts = %w(bubble_sort comb_sort selection_sort heapsort insertion_sort 
      shell_sort quicksort mergesort dualpivotquicksort)
  end

  it "should work for empty containers" do
    empty_array = []
    @sorts.each { |sort| expect(Sort.send(sort, empty_array)).to eql([]) }
  end

  it "should work for a container of size 1" do
    one_array = [1]
    @sorts.each { |sort| expect(Sort.send(sort, one_array)).to eql([1]) }
  end

  it "should work for random arrays of numbers" do
    n = 500
    rand_array = Array.new(n) { rand(n) }
    sorted_array = rand_array.sort

    @sorts.each { |sort| expect(Sort.send(sort, rand_array.dup)).to eql(sorted_array) }
  end    

end
