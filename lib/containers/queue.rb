require 'containers/deque'

=begin rdoc
    A Queue is a container that keeps elements in a first-in first-out (FIFO) order. Because of its
    properties, it is often used as a buffer.
    
    This implementation uses a doubly-linked list, guaranteeing O(1) complexity for all operations.
    
=end
class Containers::Queue
  include Enumerable
  # Create a new queue. Takes an optional array argument to initialize the queue.
  #
  #   q = Containers::Queue.new([1, 2, 3])
  #   q.pop #=> 1
  #   q.pop #=> 2
  def initialize(ary=[])
    @container = Containers::Deque.new(ary)
  end
   
  # Returns the next item from the queue but does not remove it.
  #
  #   q = Containers::Queue.new([1, 2, 3])
  #   q.next #=> 1
  #   q.size #=> 3
  def next
    @container.front
  end
      
  # Adds an item to the queue.
  #
  #   q = Containers::Queue.new([1])
  #   q.push(2)
  #   q.pop #=> 1
  #   q.pop #=> 2
  def push(obj)
    @container.push_back(obj)
  end
  alias_method :<<, :push
  
  # Removes the next item from the queue and returns it.
  #
  #   q = Containers::Queue.new([1, 2, 3])
  #   q.pop #=> 1
  #   q.size #=> 2
  def pop
    @container.pop_front
  end
  
  # Return the number of items in the queue.
  #
  #   q = Containers::Queue.new([1, 2, 3])
  #   q.size #=> 3
  def size
    @container.size
  end
  
  # Returns true if the queue is empty, false otherwise.
  def empty?
    @container.empty?
  end
  
  # Iterate over the Queue in FIFO order.
  def each(&block)
    @container.each_forward(&block)
  end

end