$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Algorithms

require 'rubygems'
require 'rbench'

RBench.run(5) do
  %w(fibonacci binary).each { |s| self.send(:column, s.intern) }
  
  random_array = Array.new(1000) { |i| rand(i) }
  
  report "Push!" do
    fiboheap = Containers::MinHeap.new
    binheap = Containers::MinBinaryHeap.new
    fibonacci { random_array.each_with_index  { |x,index| fiboheap.push(x) } }
    binary { random_array.each_with_index { |x,index| binheap.push(x) } }
  end
  
  report "Pop!" do
    fiboheap = Containers::Heap.new(random_array)
    binheap = Containers::MinBinaryHeap.new(random_array)
    fibonacci { fiboheap.pop until fiboheap.empty? }
    binary { binheap.pop until binheap.empty? }
  end
  
  report "Merge!" do
    fiboheap1 = Containers::Heap.new(random_array)
    fiboheap2 = Containers::Heap.new(random_array)
    binheap1 = Containers::MinBinaryHeap.new(random_array)
    binheap2 = Containers::MinBinaryHeap.new(random_array)
    fibonacci { fiboheap1.merge!(fiboheap2) }
    binary { binheap1.merge!(binheap2) }
  end
end
