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
    class Node # :nodoc: all
      attr_accessor :object, :left, :right
      def initialize(object)
        @left = nil
        @right = nil
        @object = object
      end
      
    end
    
    attr_reader :root_array
    
    def initialize(ary=[], &block)
      @compare_function = block_given? ? block : lambda { |x, y| (x <=> y) == -1 }
      @root_array = []
      @size = 0
      if !ary.empty?
        ary.each { |n| insert(n) }
      end
    end
    
    # Return the number of items in the heap.
    def size
      @size
    end
    
    
    def peek
      return nil if @size < 1
      next_index, next_object = -1, nil
      
      @root_array.size.times do |i|
        unless @root_array[i].nil?
          if ((next_index == -1) || @compare_function.call(next_object, @root_array[i].object))
            next_index, next_object = i, @root_array[i].object
          end
        end
      end
      return next_object
    end
  
    def get_next!
      return nil if @size < 1
      next_index, next_object = -1, nil
      
      # Remove the root node containing the maximum from its power-of-2 heap
      @root_array.size.times do |i|
        unless @root_array[i].nil?
          if ((next_index == -1) || @compare_function.call(next_object, @root_array[i].object))
            next_index, next_object = i, @root_array[i].object
          end
        end
      end
      
      # Temporarily build a binomial queue containing the remaining parts of the power-of-2 heap, and merge this back into the original
      temp = []
      x = @root_array[next_index].left
      (next_index-1).downto(0) do |i|
        temp[i] = x
        x = x.right
        temp[i].right = nil
      end

      @root_array[next_index] = nil
      merge!(temp)
      @size -= 1
      return next_object
    end
  
    def insert(object)
      c = Node.new(object)
      (0..@root_array.size+1).each do |i|
        break if c.nil?
        if @root_array[i].nil?            # The spot is empty, so we use it
          @root_array[i] = c
          break
        end
        c = pair(c, @root_array[i])       # Otherwise, join the two and proceed
        @root_array[i] = nil
      end
      @size += 1
      return object
    end
  
    def merge!(otherheap)
      if (otherheap.class == Containers::Heap || otherheap.class == Containers::MinHeap || otherheap.class == Containers::MaxHeap)
        othersize = otherheap.size
        otherheap = otherheap.root_array
      end
      a, b, c = @root_array, otherheap, nil
      if(a.size < b.size) # Make sure 'a' is always bigger
        a, b = b, a
      end
      
      (0..b.size).each do |i|
        case bits(c, b[i], a[i])
        when 2 then a[i] = b[i]
        when 3 then c = pair(a[i], b[i]); a[i] = nil
        when 4 then a[i] = c; c = nil
        when 5 then c = pair(c, a[i]); a[i] = nil
        when 6..7 then c = pair(c, b[i])
        end
      end
      @root_array = a
      @size += othersize if othersize
    end
    
    private
    def bits(c, b, a)
      4*(c.nil? ? 0 : 1) + 2*(b.nil? ? 0 : 1) + (a.nil? ? 0 : 1)
    end
    
    def pair(p, q)
      if @compare_function.call(p.object, q.object)
        p.right = q.left
        q.left = p
        return q
      else
        q.right = p.left
        p.left = q
        return p
      end
    end
  end
  
  class MaxHeap < Heap
    def initialize(ary=[])
      super(ary) { |x, y| (x <=> y) == -1 }
    end
    
    def get_max!
      get_next!
    end
  end
  
  class MinHeap < Heap
    def initialize(ary=[])
      super(ary) { |x, y| (x <=> y) == 1 }
    end
    
    def get_min!
      get_next!
    end
  end
end