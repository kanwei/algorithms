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
  
  # Comb sort: A variation on bubble sort that dramatically improves performance.
  # Source: http://yagni.com/combsort/
  # Requirements: Needs to be able to compare elements with <=>, and the [] []= methods should
  # be implemented for the container.
  # Time Complexity: О(n^2)
  # Space Complexity: О(n) total, O(1) auxiliary
  # Stable: Yes
  # 
  #   Algorithms::Sort.comb_sort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]
  def self.comb_sort(container)
    container
    gap = container.size
    loop do
      gap = gap * 10/13
      gap = 11 if gap == 9 || gap == 10
      gap = 1 if gap < 1
      swapped = false
      (container.size - gap).times do |i|
        if (container[i] <=> container[i + gap]) == 1
          container[i], container[i+gap] = container[i+gap], container[i] # Swap
          swapped = true
        end
      end
      break if !swapped && gap == 1
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
    return container if container.size < 2
    (1..container.size-1).each do |i|
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
  # def self.quicksort(container)
  #   return [] if container.empty?
  #   
  #   x, *xs = container
  # 
  #   quicksort(xs.select { |i| i <  x }) + [x] + quicksort(xs.select { |i| i >= x })
  # end
  
  def self.partition(data, left, right)
    pivot = data[front]
    left += 1

    while left <= right do
      if data[frontUnknown] < pivot
        back += 1
        data[frontUnknown], data[back] = data[back], data[frontUnknown] # Swap
      end

      frontUnknown += 1
    end

    data[front], data[back] = data[back], data[front] # Swap
    back
  end


  # def self.quicksort(container, left = 0, right = container.size - 1)
  #   if left < right 
  #     middle = partition(container, left, right)
  #     quicksort(container, left, middle - 1)
  #     quicksort(container, middle + 1, right)
  #   end
  # end
  
  def self.quicksort(container)
    bottom, top = [], []
    top[0] = 0
    bottom[0] = container.size
    i = 0
    while i >= 0 do
      l = top[i]
      r = bottom[i] - 1;
      if l < r
        pivot = container[l]
        while l < r do
          r -= 1 while (container[r] >= pivot  && l < r)
          if (l < r)
            container[l] = container[r]
            l += 1
          end
          l += 1 while (container[l] <= pivot  && l < r)
          if (l < r)
            container[r] = container[l]
            r -= 1
          end
        end
        container[l] = pivot
        top[i+1] = l + 1
        bottom[i+1] = bottom[i]
        bottom[i] = l
        i += 1
      else
        i -= 1
      end
    end
    container    
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

  # Dual-Pivot Quicksort is a variation of Quicksort by Vladimir Yaroslavskiy.
  # This is an implementation of the algorithm as it was found in the original
  # research paper:
  # 
  # http://iaroslavski.narod.ru/quicksort/DualPivotQuicksort.pdf
  # 
  # Mirror:
  # http://codeblab.com/wp-content/uploads/2009/09/DualPivotQuicksort.pdf
  #
  # "This algorithm offers O(n log(n)) performance on many data sets that cause
  # other quicksorts to degrade to quadratic performance, and is typically 
  # faster than traditional (one-pivot) Quicksort implementations."
  #   -- http://download.oracle.com/javase/7/docs/api/java/util/Arrays.html
  #
  # The algorithm was improved by Vladimir Yaroslavskiy, Jon Bentley, and 
  # Joshua Bloch, and was implemented as the default sort algorithm for
  # primatives in Java 7.
  #
  # Implementation in the Java JDK as of November, 2011:
  # http://www.docjar.com/html/api/java/util/DualPivotQuicksort.java.html
  #
  # It is proved that for the Dual-Pivot Quicksort the average number 
  # of comparisons is 2*n*ln(n), the average number of swaps is 
  # 0.8*n*ln(n), whereas classical Quicksort algorithm has 2*n*ln(n) 
  # and 1*n*ln(n) respectively. This has been fully examined mathematically
  # and experimentally.
  #
  # Requirements: Container should implement #pop and include the Enumerable module.
  # Time Complexity: О(n log n) average, О(n log n) worst-case
  # Space Complexity: О(n) auxiliary
  #
  # Stable: No
  # 
  #   Algorithms::Sort.dualpivotquicksort [5, 4, 3, 1, 2] => [1, 2, 3, 4, 5]

  def self.dualpivotquicksort(container)
    return container if container.size <= 1
    dualpivot(container, 0, container.size-1, 3)
  end
 
  def self.dualpivot(container, left=0, right=container.size-1, div=3)
    length = right - left
    if length < 27 # insertion sort for tiny array
      container.each_with_index do |data,i|
        j = i - 1
        while j >= 0
          break if container[j] <= data
          container[j + 1] = container[j]
          j = j - 1
        end
        container[j + 1] = data
      end
    else # full dual-pivot quicksort
      third = length / div
      # medians
      m1 = left + third
      m2 = right - third
      if m1 <= left 
        m1 = left + 1
      end
      if m2 >= right
        m2 = right - 1
      end
      if container[m1] < container[m2]
        dualpivot_swap(container, m1, left)
        dualpivot_swap(container, m2, right)
      else
        dualpivot_swap(container, m1, right)
        dualpivot_swap(container, m2, left)
      end
      # pivots
      pivot1 = container[left]
      pivot2 = container[right]
      # pointers
      less = left + 1
      great = right -1
      # sorting
      k = less
      while k <= great
        if container[k] < pivot1
          dualpivot_swap(container, k, less += 1)
        elsif container[k] > pivot2
          while k < great && container[great] > pivot2
            great -= 1
          end
          dualpivot_swap(container, k, great -= 1)
          if container[k] < pivot1
            dualpivot_swap(container, k, less += 1)
          end
        end
        k += 1
      end
      # swaps
      dist = great - less
      if dist < 13
        div += 1
      end
      dualpivot_swap(container, less-1, left)
      dualpivot_swap(container, great+1, right)
      # subarrays
      dualpivot(container, left, less-2, div)
      dualpivot(container, great+2, right, div)
      # equal elements
      if dist > length - 13 && pivot1 != pivot2
        for k in less..great do
          if container[k] == pivot1
            dualpivot_swap(container, k, less)
            less += 1
          elsif container[k] == pivot2
            dualpivot_swap(container, k, great)
            great -= 1
            if container[k] == pivot1
              dualpivot_swap(container, k, less)
              less += 1
            end
          end
        end
      end
      # subarray
      if pivot1 < pivot2
        dualpivot(container, less, great, div)
      end
      container
    end
  end

  def self.dualpivot_swap(container, i, j)
    container[i],  container[j] = container[j],  container[i]
  end
end

