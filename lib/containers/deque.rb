module Containers
=begin rdoc
    A Deque is a container that allows items to be added and removed from both the front and back,
    acting as a combination of a Stack and Queue.

    This implementation uses a doubly-linked list, guaranteeing O(1) complexity for all operations.
=end
  class Deque
    include Enumerable
    # Create a new stack. Takes an optional array argument to initialize the stack.
    #
    #   d = Containers::Deque.new([1, 2, 3])
    #   d.front #=> 1
    #   d.back #=> 3
    def initialize(ary=[])
      @front = nil
      @back = nil
      @size = 0
      ary.each { |obj| push_back(obj) }
    end
    
    # Returns true if the Deque is empty, false otherwise.
    def empty?
      @size == 0
    end
    
    # Return the number of items in the stack.
    #
    #   d = Containers::Deque.new([1, 2, 3])
    #   d.size #=> 3
    def size
      @size
    end
    
    # Returns the object at the front of the Deque but does not remove it.
    #
    #   d = Containers::Deque.new
    #   d.push_front(1)
    #   d.push_front(2)
    #   d.front #=> 2
    def front
      @front ? @front.obj : nil
    end
    
    # Returns the object at the back of the Deque but does not remove it.
    #
    #   d = Containers::Deque.new
    #   d.push_front(1)
    #   d.push_front(2)
    #   d.back #=> 1
    def back
      @back ? @back.obj : nil
    end
    
    # Adds an object at the front of the Deque.
    #
    #   d = Containers::Deque.new([1, 2, 3])
    #   d.push_front(0)
    #   d.pop_front #=> 0
    def push_front(obj)
      node = Node.new(obj)
      if @front.nil?
        @front = @back = node
      else
        node.left = @front.left
        node.right = @front.right
        node.left.right = node
        node.right.left = node
        @front = node
      end
      @size += 1
      obj
    end
    
    # Adds an object at the front of the Deque.
    #
    #   d = Containers::Deque.new([1, 2, 3])
    #   d.push_back(4)
    #   d.pop_back #=> 4
    def push_back(obj)
      node = Node.new(obj)
      if @back.nil?
        @front = @back = node
      else
        node.left = @back.left
        node.right = @back.right
        node.left.right = node
        node.right.left = node
        @back = node
      end
      @size += 1
      obj
    end
    
    # Returns the object at the front of the Deque and removes it.
    #
    #   d = Containers::Deque.new
    #   d.push_front(1)
    #   d.push_front(2)
    #   d.pop_front #=> 2
    #   d.size #=> 1
    def pop_front
      return nil if @front.nil?
      node = @front
      if @size == 1
        @front = @back = nil
      else
        @front.left.right = node.right
        @front.right.left = node.left
        @front = node.right
      end
      @size -= 1
      node.obj
    end
    
    # Returns the object at the back of the Deque and removes it.
    #
    #   d = Containers::Deque.new
    #   d.push_front(1)
    #   d.push_front(2)
    #   d.pop_back #=> 1
    #   d.size #=> 1
    def pop_back
      return nil if @back.nil?
      node = @back
      if @size == 1
        @front = @back = nil
      else
        @back.left.right = node.right
        @back.right.left = node.left
        @back = node.left
      end
      @size -= 1
      node.obj
    end
    
    # Iterate over the Deque in FIFO order.
    def each_forward
      return if @front.nil?
      node = @front
      loop do
        yield node.obj
        break if node.right == @front
        node = node.right
      end
    end
    alias :each :each_forward
    
    # Iterate over the Deque in LIFO order.
    def each_backward
      return if @back.nil?
      node = @back
      loop do
        yield node.obj
        break if node.left == @back
        node = node.left
      end
    end
    
    private
    
    class Node # :nodoc: all
      attr_accessor :left, :right, :obj
      
      def initialize(obj)
        @left = self
        @right = self
        @obj = obj
      end
    end
  end
end