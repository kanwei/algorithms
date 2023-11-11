$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Algorithms

require 'rubygems'
require 'rbench'

TIMES = 10_000
ELEMENTS = []
TIMES.times { ELEMENTS << Random.rand('a'.ord .. 'z'.ord).chr }

RBench.run(2) do
  %w(array heap).each { |s| self.send(:column, s.intern) }

  report "Insertion then sort" do
    heap = Containers::MinHeap.new
    array = []
  
    array do
      TIMES.times do |x|
        array << x
        array.sort!
      end
    end

    heap do
      TIMES.times { |x| heap.push(x.ord, x) }
    end
  end

  report "Swapping two elements" do
    heap = Containers::MinHeap.new
    ELEMENTS.each_with_index do |x, i|
      heap.push(i, x)
    end
    array = ELEMENTS.sort

    array do
      10_000.times do
        i = Random.rand(0..ELEMENTS.size-1)
        j = Random.rand(0..ELEMENTS.size-1)
        x = array[i]
        y = array[j]
        array[i] = y
        array[j] = x
        array.sort!
      end
    end

    heap do
      10_000.times do 
        i = Random.rand(0..ELEMENTS.size-1)
        j = Random.rand(0..ELEMENTS.size-1)
        x = heap.delete(i)
        y = heap.delete(j)
        heap.push(j, x)
        heap.push(i, y)
      end
    end
  end

  report "Promoting one element" do
    heap = Containers::MinHeap.new
    ELEMENTS.each_with_index do |x, i|
      heap.push(i, x)
    end
    array = ELEMENTS.sort

    array do
      10_000.times do
        i = Random.rand(0..ELEMENTS.size-1)
        j = Random.rand(0..i)
        x = array[i]
        array[j] = [x, array[j]]
        array[i] = nil

        array = array.flatten.compact.sort
      end
    end

    heap do
      10_000.times do 
        i = Random.rand(0..ELEMENTS.size-1)
        j = Random.rand(0..i)
        heap.change_key(i, j)
      end
    end
  end
end
