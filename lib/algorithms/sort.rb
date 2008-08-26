require 'containers/heap'

=begin rdoc
    This module implements sorting algorithms. Documentation is provided for each algorithm.
    
=end
module Algorithms::Sort
  # Bubble sort: A very naive sort that keeps swapping elements until the container is sorted.
  # Requirements: Needs to be able to compare elements with <=>, and the [] []= methods should
  # be implemented for the container.
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].bubble_sort => [1, 2, 3, 4, 5]
  def bubble_sort
    container = self.dup
    loop do
      swapped = false
      (size-1).times do |i|
        if (container[i] <=> container[i+1]) == 1
          container[i], container[i+1] = container[i+1], container[i] # Swap
          swapped = true
        end
      end
      break unless swapped
    end
    container
  end
  
  # Selection sort: A naive sort that goes through the container and selects the smallest element,
  # putting it at the beginning. Repeat until the end is reached.
  # Requirements: Needs to be able to compare elements with <=>, and the [] []= methods should
  # be implemented for the container.
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].selection_sort => [1, 2, 3, 4, 5]
  def selection_sort
    container = self.dup
    0.upto(size-1) do |i|
      min = i
      (i+1).upto(size-1) do |j|
        min = j if (container[j] <=> container[min]) == -1
      end
      container[i], container[min] = container[min], container[i] # Swap
    end
    container
  end
  
  # Heap sort: Uses a heap (implemented by the Containers module) to sort the collection.
  # Requirements: Needs to be able to compare elements with <=>
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].heapsort => [1, 2, 3, 4, 5]
  def heapsort
    heap = Containers::Heap.new(self)
    ary = []
    ary << heap.pop until heap.empty?
    ary
  end
  
  # Insertion sort: Elements are inserted sequentially into the right position.
  # Requirements: Needs to be able to compare elements with <=>, and the [] []= methods should
  # be implemented for the container.
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].insertion_sort => [1, 2, 3, 4, 5]
  def insertion_sort
    container = self.dup
    1.upto(size-1).each do |i|
      value = container[i]
      j = i-1
      while j >= 0 and container[j] > value do
        container[j+1] = container[j]
        j = j-1
      end
      container[j+1] = value
    end
    container
  end
  
  # Shell sort: Similar approach as insertion sort but slightly better.
  # Requirements: Needs to be able to compare elements with <=>, and the [] []= methods should
  # be implemented for the container.
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].shell_sort => [1, 2, 3, 4, 5]
  def shell_sort
    container = self.dup
    increment = size/2
    while increment > 0 do
      (increment..size-1).each do |i|
        temp = container[i]
        j = i
        while j >= increment && container[j - increment] > temp do
          container[j] = container[j-increment]
          j -= increment
        end
        container[j] = temp
      end
      increment = (increment == 2 ? 1 : (increment / 2.2).round)
    end
    container
  end
  
  # Quicksort: A divide-and-conquer sort that recursively partitions a container until it is sorted.
  # Requirements: Container should implement #pop and include the Enumerable module.
  # Time Complexity: О(n log n) average, O(n^2) worst-case
  # Space Complexity: О(n) auxiliary
  # Stable: No
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].quicksort => [1, 2, 3, 4, 5]
  def quicksort
    container = self.dup
    qsort(container)
  end
  
  def qsort(container)
    return container if container.size <= 1
    pivot = container.pop
    left, right = container.partition { |n| n < pivot }
    qsort(left) + [pivot] + qsort(right)
  end
  private :qsort
  
  # Mergesort: A stable divide-and-conquer sort that sorts small chunks of the container and then merges them together.
  # Returns an array of the sorted elements.
  # Requirements: Container should implement []
  # Time Complexity: О(n log n) average and worst-case
  # Space Complexity: О(n) auxiliary
  # Stable: Yes
  # 
  #   class Array; include Algorithms::Sort; end
  #   [5, 4, 3, 1, 2].mergesort => [1, 2, 3, 4, 5]
  def mergesort
    container = self.dup
    mergesort_recursive(container)
  end
  
  def mergesort_recursive(container)
    return container if container.size <= 1
    mid   = container.size / 2
    left  = container[0, mid]
    right = container[mid, container.size]
    merge(mergesort_recursive(left), mergesort_recursive(right))
  end
  private :mergesort_recursive

  def merge(left, right)
    sorted = []
    until left.empty? or right.empty?
      if left.first <= right.first
        sorted << left.shift
      else
        sorted << right.shift
      end
    end
    sorted.concat(left).concat(right)
  end
  private :merge  

end
