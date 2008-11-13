require 'containers/heap'

=begin rdoc
    A Priority Queue is a data structure that behaves like a queue except that elements have an
    associated priority. The #next and #pop methods return the item with the next highest priority.
    
    Priority Queues are often used in graph problems, such as Dijkstra's Algorithm for shortest
    path, and the A* search algorithm for shortest path.
    
    This container is implemented using the Fibonacci heap included in the Collections library.
=end
class Containers::PriorityQueue
  include Enumerable
  
  # Create a new, empty PriorityQueue
  def initialize(&block)
    # We default to a priority queue that returns the largest value
    block ||= lambda { |x, y| (x <=> y) == 1 }
    @heap = Containers::Heap.new(&block)
  end
  
  # Returns the number of elements in the queue.
  # 
  #    q = Containers::PriorityQueue.new
  #    q.size #=> 0
  #    q.push("Alaska", 1)
  #    q.size #=> 1
  def size
    @heap.size
  end
  alias_method :length, :size

  # Add an object to the queue with associated priority.
  # 
  #   q = Containers::PriorityQueue.new
  #   q.push("Alaska", 1)
  #   q.pop #=> "Alaska"
  def push(object, priority)    
    @heap.push(priority, object)
  end
  
  # Clears all the items in the queue.
  def clear
    @heap.clear
  end
  
  # Returns true if the queue is empty, false otherwise.
  def empty?
    @heap.empty?
  end

  # call-seq:
  #     has_priority? priority -> boolean
  #     
  # Return true if the priority is in the queue, false otherwise.
  #
  #     q = PriorityQueue.new
  #     q.push("Alaska", 1)
  #
  #     q.has_priority?(1)    #=> true 
  #     q.has_priority?(2)    #=> false
  def has_priority?(priority)
    @heap.has_key?(priority)
  end
  
  # call-seq:
  #     next -> object
  #
  # Return the object with the next highest priority, but does not remove it
  #
  #     q = Containers::PriorityQueue.new
  #     q.push("Alaska", 50)
  #     q.push("Delaware", 30)
  #     q.push("Georgia", 35)
  #     q.next          #=> "Alaska"
  def next
    @heap.next
  end
  
  # call-seq:
  #     pop -> object
  #
  # Return the object with the next highest priority and removes it from the queue
  #
  #     q = Containers::PriorityQueue.new
  #     q.push("Alaska", 50)
  #     q.push("Delaware", 30)
  #     q.push("Georgia", 35)
  #     q.pop         #=> "Alaska"
  #     q.size        #=> 2
  def pop
    @heap.pop
  end
  alias_method :next!, :pop

  # call-seq:
  #     delete(priority) -> object
  #     delete(priority) -> nil
  #
  # Delete an object with specified priority from the queue. If there are duplicates, an
  # arbitrary object with that priority is deleted and returned. Returns nil if there are 
  # no objects with the priority.
  #
  #     q = PriorityQueue.new
  #     q.push("Alaska", 50)
  #     q.push("Delaware", 30)
  #     q.delete(50)            #=> "Alaska"
  #     q.delete(10)            #=> nil
  def delete(priority)
    @heap.delete(priority)
  end

end