module Containers
=begin rdoc
    A Heap is a container that satisfies the heap property that nodes are always smaller in
    value than their parent node.
    
    The Containers::Heap class is flexible and upon initialization, takes an optional block
    that determines how the items are ordered. Two versions that are included are the
    Containers::MaxHeap and Containers::MinHeap that return the largest and smallest items on
    each invocation, respectively.
    
=end
  class Heap
    include Enumerable
    
    def size
      @size
    end
    alias :length :size

    def initialize(ary=[], &block)
      @compare_fn = block_given? ? block : lambda { |x, y| (x <=> y) == -1 }
      @next = nil
      @size = 0
      
      ary.each { |n| push(n, n) } unless ary.empty?
    end
    
    def push(key, value)    
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
      # puts "#{arr.join('-')}, #{@next.value}"
      value
    end
    
    def next
      @next.value
    end
    
    def clear
      @next = nil
      @size = 0
    end
    
    # Returns true if the heap is empty, false otherwise.
    def empty?
      @next.nil?
    end
    
    def merge!(otherheap)
      raise "Trying to merge a heap with something not a heap" if !otherheap.kind_of? Heap
      other_root = otherheap.instance_variable_get("@next")
      # print_roots(other_root)
      # print_roots(@next)
      if !other_root.nil?
        # Insert othernode's @next node to the left of current @next
        @next.left.right = other_root
        ol = other_root.left
        other_root.left = @next.left
        ol.right = @next
        @next.left = ol
        
        # print_roots(@next)
        if @compare_fn[other_root.key, @next.key]
          @next = other_root
        end
      end
      @size += otherheap.size
      # print_roots(@next)
    end

    def pop
      return nil if @next.nil?
      
      popped = @next
      if @size == 1
        @next = nil
        @size = 0
        return popped.value
      end
      # puts "popping #{@next.value}"
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
        # print_roots(@next)
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

      @size -= 1
      popped.value      
    end 
    
    private
    
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
      # puts "#{child.left.value}-#{child.value}-#{child.right.value}"
      # puts "Children of #{child.parent.value}: "
      # print_roots(child)
    end
    
    def print_roots(node)
      roots = []
      root = node
      loop do
        roots << root
        root = root.right
        break if root == node
      end
      p roots.collect{ |r| r.value }
    end

    def consolidate
      # puts "#{@next.left.value}-#{@next.value}-#{@next.right.value}"
      roots = []
      root = @next
      min = root
      # check if there's a new minimum in case popped's children were promoted
      loop do
        roots << root
        root = root.right
        break if root == @next
      end
      # print_roots(@next)
      degrees = []
      roots.each do |root|
        min = root if @compare_fn[root.key, min.key]
        # check if we need to merge
        if degrees[root.degree].nil?
          # puts "Not merging #{root.value}"
          degrees[root.degree] = root
          next
        else
          degree = root.degree
          until degrees[degree].nil? do
            other_root_with_degree = degrees[degree]
            if @compare_fn[root.key, other_root_with_degree.key]
              smaller, larger = root, other_root_with_degree
            else
              smaller, larger = other_root_with_degree, root
            end
            # puts "Making #{larger.value} a child of #{smaller.value}"
            link_nodes(larger, smaller)
            degrees[degree] = nil
            root = smaller
            degree += 1
          end
          degrees[degree] = root
          min = root if min.key == root.key
        end
      end
      @next = min
      # print_roots(@next)
      # puts "ending consolidate: root: #{@next.value}"
    end
    
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
    
    def cut(x, y)
      x.left.right = x.right
      x.right.left = x.left
      y.degree -= 1
      if (y.degree == 0)
        y.child = nil
      elsif (y.child == x)
        y.child = x.right
      end
      x.right = min
      x.left = min.left
      min.left = x
      x.left.right = x
      x.parent = nil
      x.marked = false
    end
  end
  
  class MaxHeap < Heap
    def initialize(ary=[])
      super(ary) { |x, y| (x <=> y) == 1 }
    end
    
    def max
      self.next
    end
    
    def max!
      self.pop
    end
  end
  
  class MinHeap < Heap
    def initialize(ary=[])
      super(ary) { |x, y| (x <=> y) == -1 }
    end
    
    def min
      self.next
    end
    
    def min!
      self.pop
    end
  end
end
