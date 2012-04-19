=begin rdoc
    A Heap is a container that satisfies the heap property that nodes are always smaller in
    value than their parent node.
    
    The Containers::Heap class is flexible and upon initialization, takes an optional block
    that determines how the items are ordered. Two versions that are included are the
    Containers::MaxHeap and Containers::MinHeap that return the largest and smallest items on
    each invocation, respectively.
    
    This library implements a Fibonacci heap, which allows O(1) complexity for most methods.
=end
class Containers::Heap
  include Enumerable
  
  # call-seq:
  #     size -> int
  #
  # Return the number of elements in the heap.
  def size
    @size
  end
  alias_method :length, :size
  
  # call-seq:
  #     Heap.new(optional_array) { |x, y| optional_comparison_fn } -> new_heap
  #
  # If an optional array is passed, the entries in the array are inserted into the heap with
  # equal key and value fields. Also, an optional block can be passed to define the function
  # that maintains heap property. For example, a min-heap can be created with:
  #
  #     minheap = Heap.new { |x, y| (x <=> y) == -1 }
  #     minheap.push(6)
  #     minheap.push(10)
  #     minheap.pop #=> 6
  #
  # Thus, smaller elements will be parent nodes. The heap defaults to a min-heap if no block
  # is given.
  def initialize(ary=[], &block)
    @compare_fn = block || lambda { |x, y| (x <=> y) == -1 }
    @next = nil
    @size = 0
    @stored = {}
    
    ary.each { |n| push(n) } unless ary.empty?
  end
  
  # call-seq:
  #     push(key, value) -> value
  #     push(value) -> value
  # 
  # Inserts an item with a given key into the heap. If only one parameter is given,
  # the key is set to the value.
  #
  # Complexity: O(1)
  #
  #     heap = MinHeap.new
  #     heap.push(1, "Cat")
  #     heap.push(2)
  #     heap.pop #=> "Cat"
  #     heap.pop #=> 2
  def push(key, value=key)
    raise ArgumentError, "Heap keys must not be nil." unless key
    node = Node.new(key, value)
    # Add new node to the left of the @next node
    if @next
      node.right = @next
      node.left = @next.left
      node.left.right = node
      @next.left = node
      if @compare_fn[key, @next.key]
        @next = node
      end
    else
      @next = node
    end
    @size += 1
    
    arr = []
    w = @next.right
    until w == @next do
      arr << w.value
      w = w.right
    end
    arr << @next.value
    @stored[key] ||= []
    @stored[key] << node
    value
  end
  alias_method :<<, :push
  
  # call-seq:
  #     has_key?(key) -> true or false
  #
  # Returns true if heap contains the key.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.has_key?(2) #=> true
  #     minheap.has_key?(4) #=> false
  def has_key?(key)
    @stored[key] && !@stored[key].empty? ? true : false
  end
  
  # call-seq:
  #     next -> value
  #     next -> nil
  #
  # Returns the value of the next item in heap order, but does not remove it.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.next #=> 1
  #     minheap.size #=> 2
  def next
    @next && @next.value
  end
  
  # call-seq:
  #     next_key -> key
  #     next_key -> nil
  #
  # Returns the key associated with the next item in heap order, but does not remove the value.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new
  #     minheap.push(1, :a)
  #     minheap.next_key #=> 1
  #
  def next_key
    @next && @next.key
  end
  
  # call-seq:
  #     clear -> nil
  #
  # Removes all elements from the heap, destructively.
  #
  # Complexity: O(1)
  #
  def clear
    @next = nil
    @size = 0
    @stored = {}
    nil
  end
  
  # call-seq:
  #     empty? -> true or false
  #
  # Returns true if the heap is empty, false otherwise.
  def empty?
    @next.nil?
  end
  
  # call-seq:
  #     merge!(otherheap) -> merged_heap
  #
  # Does a shallow merge of all the nodes in the other heap.
  #
  # Complexity: O(1)
  #
  #     heap = MinHeap.new([5, 6, 7, 8])
  #     otherheap = MinHeap.new([1, 2, 3, 4])
  #     heap.merge!(otherheap)
  #     heap.size #=> 8
  #     heap.pop #=> 1
  def merge!(otherheap)
    raise ArgumentError, "Trying to merge a heap with something not a heap" unless otherheap.kind_of? Containers::Heap
    other_root = otherheap.instance_variable_get("@next")
    if other_root
      @stored = @stored.merge(otherheap.instance_variable_get("@stored")) { |key, a, b| (a << b).flatten }
      # Insert othernode's @next node to the left of current @next
      @next.left.right = other_root
      ol = other_root.left
      other_root.left = @next.left
      ol.right = @next
      @next.left = ol
      
      @next = other_root if @compare_fn[other_root.key, @next.key]
    end
    @size += otherheap.size
  end
  
  # call-seq:
  #     pop -> value
  #     pop -> nil
  #
  # Returns the value of the next item in heap order and removes it from the heap.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.pop #=> 1
  #     minheap.size #=> 1
  def pop
    return nil unless @next
    popped = @next
    if @size == 1
      clear
      return popped.value
    end
    # Merge the popped's children into root node
    if @next.child
      @next.child.parent = nil
      
      # get rid of parent
      sibling = @next.child.right
      until sibling == @next.child
        sibling.parent = nil
        sibling = sibling.right
      end
      
      # Merge the children into the root. If @next is the only root node, make its child the @next node
      if @next.right == @next
        @next = @next.child
      else
        next_left, next_right = @next.left, @next.right
        current_child = @next.child
        @next.right.left = current_child
        @next.left.right = current_child.right
        current_child.right.left = next_left
        current_child.right = next_right
        @next = @next.right
      end
    else
      @next.left.right = @next.right
      @next.right.left = @next.left
      @next = @next.right
    end
    consolidate
    
    unless @stored[popped.key].delete(popped)
      raise "Couldn't delete node from stored nodes hash" 
    end
    @size -= 1
    
    popped.value
  end
  alias_method :next!, :pop
  
  # call-seq:
  #     change_key(key, new_key) -> [new_key, value]
  #     change_key(key, new_key) -> nil
  #
  # Changes the key from one to another. Doing so must not violate the heap property or
  # an exception will be raised. If the key is found, an array containing the new key and 
  # value pair is returned, otherwise nil is returned. 
  #
  # In the case of duplicate keys, an arbitrary key is changed. This will be investigated
  # more in the future.
  #
  # Complexity: amortized O(1)
  # 
  #     minheap = MinHeap.new([1, 2])
  #     minheap.change_key(2, 3) #=> raise error since we can't increase the value in a min-heap
  #     minheap.change_key(2, 0) #=> [0, 2]
  #     minheap.pop #=> 2
  #     minheap.pop #=> 1
  def change_key(key, new_key, delete=false)
    return if @stored[key].nil? || @stored[key].empty? || (key == new_key)
    
    # Must maintain heap property
    raise "Changing this key would not maintain heap property!" unless (delete || @compare_fn[new_key, key])
    node = @stored[key].shift
    if node
      node.key = new_key
      @stored[new_key] ||= []
      @stored[new_key] << node
      parent = node.parent
      if parent
        # if heap property is violated
        if delete || @compare_fn[new_key, parent.key]
          cut(node, parent)
          cascading_cut(parent)
        end
      end
      if delete || @compare_fn[node.key, @next.key]
        @next = node
      end
      return [node.key, node.value]
    end
    nil
  end
  
  # call-seq:
  #     delete(key) -> value
  #     delete(key) -> nil
  #
  # Deletes the item with associated key and returns it. nil is returned if the key 
  # is not found. In the case of nodes with duplicate keys, an arbitrary one is deleted.
  #
  # Complexity: amortized O(log n)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.delete(1) #=> 1
  #     minheap.size #=> 1
  def delete(key)
    pop if change_key(key, nil, true)
  end
  
  # Node class used internally
  class Node # :nodoc:
    attr_accessor :parent, :child, :left, :right, :key, :value, :degree, :marked

    def initialize(key, value)
      @key = key
      @value = value
      @degree = 0
      @marked = false
      @right = self
      @left = self
    end
    
    def marked?
      @marked == true
    end
    
  end
  
  # make node a child of a parent node
  def link_nodes(child, parent)
    # link the child's siblings
    child.left.right = child.right
    child.right.left = child.left

    child.parent = parent
    
    # if parent doesn't have children, make new child its only child
    if parent.child.nil?
      parent.child = child.right = child.left = child
    else # otherwise insert new child into parent's children list
      current_child = parent.child
      child.left = current_child
      child.right = current_child.right
      current_child.right.left = child
      current_child.right = child
    end
    parent.degree += 1
    child.marked = false
  end
  private :link_nodes
  
  # Makes sure the structure does not contain nodes in the root list with equal degrees
  def consolidate
    roots = []
    root = @next
    min = root
    # find the nodes in the list
    loop do
      roots << root
      root = root.right
      break if root == @next
    end
    degrees = []
    roots.each do |root|
      min = root if @compare_fn[root.key, min.key]
      # check if we need to merge
      if degrees[root.degree].nil?  # no other node with the same degree
        degrees[root.degree] = root
        next
      else  # there is another node with the same degree, consolidate them
        degree = root.degree
        until degrees[degree].nil? do
          other_root_with_degree = degrees[degree]
          if @compare_fn[root.key, other_root_with_degree.key]  # determine which node is the parent, which one is the child
            smaller, larger = root, other_root_with_degree
          else
            smaller, larger = other_root_with_degree, root
          end
          link_nodes(larger, smaller)
          degrees[degree] = nil
          root = smaller
          degree += 1
        end
        degrees[degree] = root
        min = root if min.key == root.key # this fixes a bug with duplicate keys not being in the right order
      end
    end
    @next = min
  end
  private :consolidate
  
  def cascading_cut(node)
    p = node.parent
    if p
      if node.marked?
        cut(node, p)
        cascading_cut(p)
      else
        node.marked = true
      end
    end
  end
  private :cascading_cut
  
  # remove x from y's children and add x to the root list
  def cut(x, y)
    x.left.right = x.right
    x.right.left = x.left
    y.degree -= 1
    if (y.degree == 0)
      y.child = nil
    elsif (y.child == x)
      y.child = x.right
    end
    x.right = @next
    x.left = @next.left
    @next.left = x
    x.left.right = x
    x.parent = nil
    x.marked = false
  end
  private :cut
  
end

# A MaxHeap is a heap where the items are returned in descending order of key value.
class Containers::MaxHeap < Containers::Heap
  
  # call-seq:
  #     MaxHeap.new(ary) -> new_heap
  #
  # Creates a new MaxHeap with an optional array parameter of items to insert into the heap.
  # A MaxHeap is created by calling Heap.new { |x, y| (x <=> y) == 1 }, so this is a convenience class.
  #
  #     maxheap = MaxHeap.new([1, 2, 3, 4])
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
  #     maxheap = MaxHeap.new([1, 2, 3, 4])
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
  #     maxheap = MaxHeap.new([1, 2, 3, 4])
  #     maxheap.max! #=> 4
  #     maxheap.size #=> 3
  def max!
    self.pop
  end
end

# A MinHeap is a heap where the items are returned in ascending order of key value.
class Containers::MinHeap < Containers::Heap
  
  # call-seq:
  #     MinHeap.new(ary) -> new_heap
  #
  # Creates a new MinHeap with an optional array parameter of items to insert into the heap.
  # A MinHeap is created by calling Heap.new { |x, y| (x <=> y) == -1 }, so this is a convenience class.
  #
  #     minheap = MinHeap.new([1, 2, 3, 4])
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
  #     minheap = MinHeap.new([1, 2, 3, 4])
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
  #     minheap = MinHeap.new([1, 2, 3, 4])
  #     minheap.min! #=> 1
  #     minheap.size #=> 3
  def min!
    self.pop
  end
end