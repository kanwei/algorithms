require 'containers/deque'
=begin rdoc
    A Stack is a container that keeps elements in a last-in first-out (LIFO) order. There are many
    uses for stacks, including prefix-infix-postfix conversion and backtracking problems.

    This implementation uses a doubly-linked list, guaranteeing O(1) complexity for all operations.

=end
class Containers::Stack
  include Enumerable
  # Create a new stack. Takes an optional array argument to initialize the stack.
  #
  #   s = Containers::Stack.new([1, 2, 3])
  #   s.pop #=> 3
  #   s.pop #=> 2
  def initialize(ary=[])
    @container = Containers::Deque.new(ary)
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
  alias_method :<<, :push
  
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