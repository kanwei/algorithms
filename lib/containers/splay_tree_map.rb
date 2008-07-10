module Containers
=begin rdoc
    A SplayTreeMap is a map that is stored in ascending order of its keys, determined by applying
    the function <=> to compare keys. No duplicate values for keys are allowed, so new values of a key
    overwrites the old value of the key.
    
    A major advantage of SplayTreeMap over a Hash is the fact that keys are stored in order and can thus be
    iterated over in order. Also, Splay Trees are self-optimizing as recently accessed nodes stay near
    the root and are easily re-accessed later. Splay Trees are also more simply implemented than Red-Black
    trees.
    
=end
  class SplayTreeMap
    include Enumerable
    
    # Create and initialize a new empty SplayTreeMap.
    def initialize
      @root = nil
      @header = Node.new(nil, nil)
      @size = 0
    end
    
    # Insert an item with an associated key into the SplayTreeMap, and returns the item inserted
    #
    # map = Containers::SplayTreeMap.new
    # map.push("MA", "Massachusetts") #=> "Massachusetts"
    # map.get("MA") #=> "Massachusetts"
    def push(key, value)
      if @root.nil?
        @root = Node.new(key, value)
        @size = 1
        return value
      end
      splay(key)
      
      cmp = (key <=> @root.key)
      if cmp == 0
        @root.value = value
        return value
      end
      node = Node.new(key, value)
      if cmp < 1
        node.left = @root.left
        node.right = @root
        @root.left = nil
      else
        node.right = @root.right
        node.left = @root
        @root.right = nil
      end
      @root = node
      @size += 1
      value
    end
    alias :[]= :push
    
    # Return the number of items in the SplayTreeMap.
    #
    #   map = Containers::SplayTreeMap.new
    #   map.push("MA", "Massachusetts")
    #   map.push("GA", "Georgia")
    #   map.size #=> 2
    def size
      @size
    end
    
    # Remove all elements from the SplayTreeMap
    def clear
      @root = nil
      @size = 0
      @header = Node.new(nil, nil)
    end
    
    # Return the height of the tree structure in the SplayTreeMap.
    #
    #   map = Containers::SplayTreeMap.new
    #   map.push("MA", "Massachusetts")
    #   map.push("GA", "Georgia")
    #   map.height #=> 2
    def height
      heightR(@root)
    end
    
    # Return true if key is found in the SplayTreeMap, false otherwise
    #
    #   map = Containers::SplayTreeMap.new
    #   map["MA"] = "Massachusetts"
    #   map["GA"] = "Georgia"
    #   map.has_key?("GA") #=> true
    #   map.has_key?("DE") #=> false
    def has_key?(key)
      !get(key).nil?
    end
    
    # Return the item associated with the key, or nil if none found.
    #
    #   map = Containers::SplayTreeMap.new
    #   map.push("MA", "Massachusetts")
    #   map.push("GA", "Georgia")
    #   map.get("GA") #=> "Georgia"
    def get(key)
      return nil if @root.nil?
      
      splay(key)
      (@root.key <=> key) == 0 ? @root.value : nil
    end
    alias :[] :get
    
    # Return the smallest [key, value] pair in the SplayTreeMap, or nil if the tree is empty.
    #
    #   map = Containers::SplayTreeMap.new
    #   map["MA"] = "Massachusetts"
    #   map["GA"] = "Georgia"
    #   map.min #=> ["GA", "Georgia"]
    def min
      return nil if @root.nil?
      n = @root
      while n.left
        n = n.left
      end
      splay(n.key)
      return [n.key, n.value]
    end
    
    # Return the largest [key, value] pair in the SplayTreeMap, or nil if the tree is empty.
    #
    #   map = Containers::SplayTreeMap.new
    #   map["MA"] = "Massachusetts"
    #   map["GA"] = "Georgia"
    #   map.max #=> ["MA", "Massachusetts"]
    def max
      return nil if @root.nil?
      n = @root
      while n.right
        n = n.right
      end
      splay(n.key)
      return [n.key, n.value]
    end
    
    # Deletes the item and key if it's found, and returns the item. Returns nil
    # if key is not present.
    #
    #   map = Containers::SplayTreeMap.new
    #   map["MA"] = "Massachusetts"
    #   map["GA"] = "Georgia"
    #   map.delete("GA") #=> "Georgia"
    #   map.delete("DE") #=> nil
    def delete(key)
      return nil if @root.nil?
      deleted = nil
      splay(key)
      if (key <=> @root.key) == 0 # The key exists
        deleted = @root.value
        if @root.left.nil?
          @root = @root.right
        else
          x = @root.right
          @root = @root.left
          splay(key)
          @root.right = x
        end
      end
      deleted
    end
    
    # Iterates over the SplayTreeMap in increasing order.
    def each(&block)
      @root.nil? ? nil : eachR(@root, block)
    end
    
    private
    
    class Node # :nodoc: all
      attr_accessor :key, :value, :left, :right
      def initialize(key, value)
        @key = key
        @value = value
        @left = nil
        @right = nil
      end
      
      def size
        self.num_nodes
      end
    end
    
    # Moves a key to the root, updating the structure in each step.
    def splay(key)
      l, r = @header, @header
      t = @root
      @header.left, @header.right = nil, nil
      
      loop do
        if (key <=> t.key) == -1
          break unless t.left
          if (key <=> t.left.key) == -1
            y = t.left
            t.left = y.right
            y.right = t
            t = y
            break unless t.left
          end
          r.left = t
          r = t
          t = t.left
        elsif (key <=> t.key) == 1
          break unless t.right
          if (key <=> t.right.key) == 1
            y = t.right
            t.right = y.left
            y.left = t
            t = y
            break unless t.right
          end
          l.right = t
          l = t
          t = t.right
        else
          break
  	    end
      end
      l.right = t.left
      r.left = t.right
      t.left = @header.right
      t.right = @header.left
      @root = t
    end
    
    # Recursively determine height
    def heightR(node)
      return 0 if node.nil?
      
      left_height   = 1 + heightR(node.left)
      right_height  = 1 + heightR(node.right)
      
      left_height > right_height ? left_height : right_height
    end
    
    # Recursively iterate over elements in ascending order
    def eachR(node, block)
      return if node.nil?
      
      eachR(node.left, block)
      block.call(node.key, node.value)
      eachR(node.right, block)
    end
  end
  
end