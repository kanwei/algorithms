=begin rdoc
    A Deque is a container that allows items to be added and removed from both the front and back,
    acting as a combination of a Stack and Queue.

    This implementation uses a doubly-linked list, guaranteeing O(1) complexity for all operations.
=end
class Containers::RubyDeque
  include Enumerable
  
  Node = Struct.new(:left, :right, :obj)
  
  # Create a new Deque. Takes an optional array argument to initialize the Deque.
  #
  #   d = Containers::Deque.new([1, 2, 3])
  #   d.front #=> 1
  #   d.back #=> 3
  def initialize(ary=[])
    @front = nil
    @back = nil
    @size = 0
    ary.to_a.each { |obj| push_back(obj) }
  end
  
  # Returns true if the Deque is empty, false otherwise.
  def empty?
    @size == 0
  end
  
  # Removes all the objects in the Deque.
  def clear
    @front = @back = nil
    @size = 0
  end
  
  # Return the number of items in the Deque.
  #
  #   d = Containers::Deque.new([1, 2, 3])
  #   d.size #=> 3
  def size
    @size
  end
  alias_method :length, :size
  
  # Returns the object at the front of the Deque but does not remove it.
  #
  #   d = Containers::Deque.new
  #   d.push_front(1)
  #   d.push_front(2)
  #   d.front #=> 2
  def front
    @front && @front.obj
  end
  
  # Returns the object at the back of the Deque but does not remove it.
  #
  #   d = Containers::Deque.new
  #   d.push_front(1)
  #   d.push_front(2)
  #   d.back #=> 1
  def back
    @back && @back.obj
  end
  
  # Adds an object at the front of the Deque.
  #
  #   d = Containers::Deque.new([1, 2, 3])
  #   d.push_front(0)
  #   d.pop_front #=> 0
  def push_front(obj)
    node = Node.new(nil, nil, obj)
    if @front
      node.right = @front
      @front.left = node
      @front = node
    else
      @front = @back = node
    end
    @size += 1
    obj
  end
  
  # Adds an object at the back of the Deque.
  #
  #   d = Containers::Deque.new([1, 2, 3])
  #   d.push_back(4)
  #   d.pop_back #=> 4
  def push_back(obj)
    node = Node.new(nil, nil, obj)
    if @back
      node.left = @back
      @back.right = node
      @back = node
    else
      @front = @back = node
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
    return nil unless @front
    node = @front
    if @size == 1
      clear
      return node.obj
    else
      @front.right.left = nil
      @front = @front.right
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
    return nil unless @back
    node = @back
    if @size == 1
      clear
      return node.obj
    else
      @back.left.right = nil
      @back = @back.left
    end
    @size -= 1
    node.obj
  end
  
  # Iterate over the Deque in FIFO order.
  def each_forward
    return unless @front
    node = @front
    while node
      yield node.obj
      node = node.right
    end
  end
  alias_method :each, :each_forward
  
  # Iterate over the Deque in LIFO order.
  def each_backward
    return unless @back
    node = @back
    while node
      yield node.obj
      node = node.left
    end
  end
  alias_method :reverse_each, :each_backward

end

begin
  require 'CDeque'
  Containers::Deque = Containers::CDeque
rescue LoadError # C Version could not be found, try ruby version
  Containers::Deque = Containers::RubyDeque
end