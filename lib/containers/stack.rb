$: << File.expand_path(File.dirname(__FILE__))
require 'deque'
include Containers

module Containers
=begin rdoc
    A Stack is a container that keeps elements in a last-in first-out (LIFO) order. There are many
    uses for stacks, including prefix-infix-postfix conversion and backtracking problems.

    The ruby Stack implementation uses an array, while the C implementation uses a linked-list, and
    has less overhead.

=end
  class Stack
    include Enumerable
    # Create a new stack. Takes an optional array argument to initialize the stack.
    #
    #   s = Containers::Stack.new([1, 2, 3])
    #   s.pop #=> 3
    #   s.pop #=> 2
    def initialize(ary=[])
      @container = Deque.new(ary)
    end
    
    # Returns the next item from the stack but does not remove it.
    #
    #   s = Containers::Stack.new([1, 2, 3])
    #   s.next #=> 3
    #   s.size #=> 3
    def next
      @container.back
    end
    
    # Adds an item to the stack.
    #
    #   s = Containers::Stack.new([1])
    #   s.push(2)
    #   s.pop #=> 2
    #   s.pop #=> 1
    def push(obj)
      @container.push_back(obj)
    end
    
    # Removes the next item from the stack and returns it.
    #
    #   s = Containers::Stack.new([1, 2, 3])
    #   s.pop #=> 3
    #   s.size #=> 2
    def pop
      @container.pop_back
    end
    
    # Return the number of items in the stack.
    #
    #   s = Containers::Stack.new([1, 2, 3])
    #   s.size #=> 3
    def size
      @container.size
    end
    
    # Returns true if the stack is empty, false otherwise.
    def empty?
      @container.empty?
    end
    
    # Iterate over the Stack in LIFO order.
    def each(&block)
      @container.each_backward(&block)
    end
  
  end
end