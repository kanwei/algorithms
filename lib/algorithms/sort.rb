require 'containers/heap' # for heapsort

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
  #   Algorithms::Sort.bubble_sort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.bubble_sort(container)
    loop do
      swapped = false
      (container.size-1).times do |i|
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
  #   Algorithms::Sort.selection_sort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.selection_sort(container)
    0.upto(container.size-1) do |i|
      min = i
      (i+1).upto(container.size-1) do |j|
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
  #   Algorithms::Sort.heapsort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.heapsort(container)
    heap = Containers::Heap.new(container)
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
  #   Algorithms::Sort.insertion_sort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.insertion_sort(container)
    1.upto(container.size-1).each do |i|
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
  #   Algorithms::Sort.shell_sort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.shell_sort(container)
    increment = container.size/2
    while increment > 0 do
      (increment..container.size-1).each do |i|
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
  #   Algorithms::Sort.quicksort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.quicksort(container)
    return container if container.size <= 1
    pivot = container.pop
    left, right = container.partition { |n| n < pivot }
    self.quicksort(left) + [pivot] + self.quicksort(right)
  end
  
  # Mergesort: A stable divide-and-conquer sort that sorts small chunks of the container and then merges them together.
  # Returns an array of the sorted elements.
  # Requirements: Container should implement []
  # Time Complexity: О(n log n) average and worst-case
  # Space Complexity: О(n) auxiliary
  # Stable: Yes
  # 
  #   Algorithms::Sort.mergesort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.mergesort(container)
    return container if container.size <= 1
    mid   = container.size / 2
    left  = container[0...mid]
    right = container[mid...container.size]
    merge(mergesort(left), mergesort(right))
  end

  def self.merge(left, right)
    sorted = []
    until left.empty? or right.empty?
      left.first <= right.first ? sorted << left.shift : sorted << right.shift
    end
    sorted + left + right
  end

end
