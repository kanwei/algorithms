=begin rdoc
    A Heap is a container that satisfies the heap property that nodes are always smaller in
    value than their parent node.
    
    The Containers::BinaryHeap class is flexible and upon initialization, takes an optional 
    block that determines how the items are ordered. Two versions that are included are the
    Containers::MaxBinaryHeap and Containers::MinBinaryHeap that return the largest and 
    smallest items on each invocation, respectively.
    
    This library implements a Binary heap, which allows O(log n) complexity for most methods,
    but with a very efficient memory setup.
=end
class Containers::BinaryHeap
  include Enumerable
  
  # call-seq:
  #     size -> int
  #
  # Return the number of elements in the heap.
  def size
    @stored.size-1
  end
  alias_method :length, :size
  
  # call-seq:
  #     Heap.new(optional_array) { |x, y| optional_comparison_fn } -> new_heap
  #
  # If an optional array is passed, the entries in the array are inserted into the heap with
  # equal key and value fields. Also, an optional block can be passed to define the function
  # that maintains heap property. For example, a min-heap can be created with:
  #
  #     minheap = BinaryHeap.new { |x, y| (x <=> y) == -1 }
  #     minheap.push(6)
  #     minheap.push(10)
  #     minheap.pop #=> 6
  #
  # Thus, smaller elements will be parent nodes. The heap defaults to a min-heap if no block
  # is given.
  #
  # Complexity: O(n)
  def initialize(ary=[], &block)
    @compare_fn = block || lambda { |x, y| (x <=> y) == -1 }
    clear(ary)
  end
  
  # call-seq:
  #     push(key, value) -> value
  #     push(value) -> value
  # 
  # Inserts an item with a given key into the heap. If only one parameter is given,
  # the key is set to the value.
  #
  # Complexity: O(log n)
  #
  #     heap = MinBinaryHeap.new
  #     heap.push(1, "Cat")
  #     heap.push(2)
  #     heap.pop #=> "Cat"
  #     heap.pop #=> 2
  def push(key, value=key)
    raise ArgumentError, "Heap keys must not be nil." unless key
    node = Node.new(key, value)
    @stored << node
    bubble_up!(size)
  end
  alias_method :<<, :push
  
  # call-seq:
  #     next -> value
  #     next -> nil
  #
  # Returns the value of the next item in heap order, but does not remove it.
  #
  # Complexity: O(1)
  #
  #     minheap = MinBinaryHeap.new([1, 2])
  #     minheap.next #=> 1
  #     minheap.size #=> 2
  def next
    @stored[1] && @stored[1].value
  end
  
  # call-seq:
  #     next_key -> key
  #     next_key -> nil
  #
  # Returns the key associated with the next item in heap order, but does not remove the value.
  #
  # Complexity: O(1)
  #
  #     minheap = MinBinaryHeap.new
  #     minheap.push(1, :a)
  #     minheap.next_key #=> 1
  #
  def next_key
    @stored[1] && @stored[1].key
  end
  
  # call-seq:
  #     clear -> nil
  #
  # Removes all elements from the heap, destructively.
  #
  # Complexity: O(1)
  #
  def clear(ary=[])
    @stored = [nil] + ary.map{|x|Node.new(x,x)}
    heapify!
    nil
  end
  
  # call-seq:
  #     empty? -> true or false
  #
  # Returns true if the heap is empty, false otherwise.
  def empty?
    size == 0
  end
  
  # call-seq:
  #     merge!(otherheap) -> merged_heap
  #
  # Does a shallow merge of all the nodes in the other heap.
  #
  # Complexity: O(n+m)
  #
  #     heap = MinBinaryHeap.new([5, 6, 7, 8])
  #     otherheap = MinBinaryHeap.new([1, 2, 3, 4])
  #     heap.merge!(otherheap)
  #     heap.size #=> 8
  #     heap.pop #=> 1
  def merge!(otherheap)
    raise ArgumentError, "Trying to merge a heap with something not a binary heap" unless otherheap.kind_of? Containers::BinaryHeap
    other_stored = otherheap.instance_variable_get("@stored")
    @stored.concat(other_stored.drop(1))
    heapify!
  end
  
  # call-seq:
  #     pop -> value
  #     pop -> nil
  #
  # Returns the value of the next item in heap order and removes it from the heap.
  #
  # Complexity: O(log n)
  #
  #     minheap = MinBinaryHeap.new([1, 2])
  #     minheap.pop #=> 1
  #     minheap.size #=> 1
  def pop
    return nil if empty?
    swap!(1, size)
    popped = @stored.pop()
    bubble_down!(1)
    return popped.value
  end
  alias_method :next!, :pop
  
  private
  
  def heapify!
    for i in (size/2).downto(1)
      bubble_down!(i)
    end
  end
  
  def bubble_up!(n)
    while n > 1 and less(n, n/2)
      swap!(n, n/2)
      n /= 2
    end
  end

  def bubble_down!(n)
    while less(n*2, n) or less(n*2+1, n)
      c = lesser(n*2, n*2+1)
      swap!(n, c)
      n = c
    end
  end

  def less(a, b)
    return false unless @stored[a]
    return true unless @stored[b]
    @compare_fn[@stored[a].key, @stored[b].key]
  end

  def lesser(a, b)
    less(a,b) ? a : b
  end

  def swap!(a, b)
    @stored[a], @stored[b] = @stored[b], @stored[a]
  end
  
  # Node class used internally
  class Node # :nodoc:
    attr_accessor :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end
  end
end

# A MaxHeap is a heap where the items are returned in descending order of key value.
class Containers::MaxBinaryHeap < Containers::BinaryHeap
  
  # call-seq:
  #     MaxBinaryHeap.new(ary) -> new_heap
  #
  # Creates a new MaxHeap with an optional array parameter of items to insert into the heap.
  # A MaxBinaryHeap is created by calling BinaryHeap.new { |x, y| (x <=> y) == 1 }, so this 
  # is a convenience class.
  #
  #     maxheap = MaxBinaryHeap.new([1, 2, 3, 4])
  #     maxheap.pop #=> 4
  #     maxheap.pop #=> 3
  def initialize(ary=[])
    super(ary) { |x, y| (x <=> y) == 1 }
  end
  
  # call-seq:
  #     max -> value
  #     max -> nil
  #
  # Returns the item with the largest key, but does not remove it from the heap.
  #
  #     maxheap = MaxBinaryHeap.new([1, 2, 3, 4])
  #     maxheap.max #=> 4
  def max
    self.next
  end
  
  # call-seq:
  #     max! -> value
  #     max! -> nil
  #
  # Returns the item with the largest key and removes it from the heap.
  #
  #     maxheap = MaxBinaryHeap.new([1, 2, 3, 4])
  #     maxheap.max! #=> 4
  #     maxheap.size #=> 3
  def max!
    self.pop
  end
end

# A MinHeap is a heap where the items are returned in ascending order of key value.
class Containers::MinBinaryHeap < Containers::BinaryHeap
  
  # call-seq:
  #     MinBinaryHeap.new(ary) -> new_heap
  #
  # Creates a new MinHeap with an optional array parameter of items to insert into the heap.
  # A MinHeap is created by calling BinaryHeap.new { |x, y| (x <=> y) == -1 }, so this is a 
  # convenience class.
  #
  #     minheap = MinBinaryHeap.new([1, 2, 3, 4])
  #     minheap.pop #=> 1
  #     minheap.pop #=> 2
  def initialize(ary=[])
    super(ary) { |x, y| (x <=> y) == -1 }
  end
  
  # call-seq:
  #     min -> value
  #     min -> nil
  #
  # Returns the item with the smallest key, but does not remove it from the heap.
  #
  #     minheap = MinBinaryHeap.new([1, 2, 3, 4])
  #     minheap.min #=> 1
  def min
    self.next
  end
  
  # call-seq:
  #     min! -> value
  #     min! -> nil
  #
  # Returns the item with the smallest key and removes it from the heap.
  #
  #     minheap = MinBinaryHeap.new([1, 2, 3, 4])
  #     minheap.min! #=> 1
  #     minheap.size #=> 3
  def min!
    self.pop
  end
end
