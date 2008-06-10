class DS
  # Use a Ruby array for storage
  class Queue
    def initialize(ary=[])
      @container = Array.new
    end
  
    def put(object)
      @container.push(object)
    end
  
    def peek
      @container[0]
    end
    
    def get
      @container.shift
    end
  
    def size
      @container.size
    end
  
    def empty?
      @container.empty?
    end
  
  end
end