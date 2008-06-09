# Use a Ruby array for storage
class Stack
  def initialize(ary=[])
    @container = Array.new
  end
  
  def push(object)
    @container.push(object)
  end
  
  def peek
    @container.last
  end
  
  def pop
    @container.pop
  end
  
  def size
    @container.size
  end
  
  def empty?
    @container.empty?
  end
  
end