module Containers
=begin rdoc
    A TreeMap is a map that is stored in sorted order based on the order of its keys. This ordering is
    determined by applying the function <=> to compare the keys. No duplicate values for keys are allowed,
    so duplicate values are overwritten.
    
    A major advantage of TreeMap over a Hash is the fact that keys are stored in order and can thus be
    iterated over in order. This is useful for many datasets.
    
    The implementation is adapted from Robert Sedgewick's Left Leaning Red-Black Tree implementation,
    which can be found at http://www.cs.princeton.edu/~rs/talks/LLRB/Java/RedBlackBST.java
    
    Containers::TreeMap automatically uses the faster C implementation if it was built 
    when the gem was installed. Alternatively, Containers::RubyTreeMap and Containers::CTreeMap can be 
    explicitly used as well; their functionality is identical.
    
=end
  class RubyTreeMap
    include Enumerable
    
    attr_accessor :height_black
    
    # Create and initialize a new empty TreeMap.
    def initialize
      @root = nil
      @height_black = 0
    end
    
    # Insert an item with an associated key into the TreeMap, and returns the item inserted
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts") #=> "Massachusetts"
    # map.get("MA") #=> "Massachusetts"
    def put(key, value)
      @root = insert(@root, key, value)
      @height_black += 1 if isred(@root)
      @root.color = :black
      value
    end
    alias :[]= :put
    
    # Return the number of items in the TreeMap.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.size #=> 2
    def size
      return 0 if @root.nil?
      @root.size
    end
    
    # Return the height of the tree structure in the TreeMap.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.height #=> 2
    def height
      heightR(@root)
    end
    
    # Return true if key is found in the TreeMap, false otherwise
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.contains_key?("GA") #=> true
    # map.contains_key?("DE") #=> false
    def contains_key?(key)
      !get(key).nil?
    end
    
    # Return the item associated with the key, or nil if none found.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.get("GA") #=> "Georgia"
    def get(key)
      getR(@root, key)
    end
    alias :[] :get
    
    # Return the smallest key in the TreeMap
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.min_key #=> "GA"
    def min_key
      @root.nil? ? nil : minR(@root)
    end
    
    # Return the largest key in the TreeMap
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.max_key #=> "MA"
    def max_key
      @root.nil? ? nil : maxR(@root)
    end
    
    # Deletes the item and key if it's found, and returns the item. Returns nil
    # if key is not present.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.min_key #=> "GA"
    def delete(key)
      result = nil
      if @root
        @root, result = deleteR(@root, key)
        @root.color = :black
      end
      result
    end
    
    # Iterates over the TreeMap from smallest to largest element
    def each(&block)
      @root.nil? ? nil : eachR(@root, block)
    end
    
    def to_s
      return "" if @root.nil?
      "#{@height_black} #{to_sR(@root)}"
    end
    
    private
    
    class Node # :nodoc: all
      attr_accessor :color, :key, :value, :left, :right, :num_nodes, :height
      def initialize(key, value)
        @key = key
        @value = value
        @color = :red
        @left = nil
        @right = nil
        @num_nodes = 1
        @height = 1
      end
      
      def size
        self.num_nodes
      end
    end
    
    def eachR(node, block)
      return if node.nil?
      
      eachR(node.left, block)
      block.call(node.key, node.value)
      eachR(node.right, block)
    end
    
    def deleteR(node, key)
      if (key <=> node.key) == -1
        node = move_red_left(node) if (!isred(node.left) && !isred(node.left.left))
        node.left, result = deleteR(node.left, key)
      else
        node = rotate_right(node) if isred(node.left)
        if ( ( (key <=> node.key) == 0) && node.right.nil? )
          return nil, node.value
        end
        if (!isred(node.right) && !isred(node.right.left))
          node = move_red_right(node);
        end
        if (key <=> node.key) == 0
          result = node.value
          node.value = getR(node.right, minR(node.right))
          node.key = minR(node.right)
          node.right = delete_minR(node.right)
        else
          node.right, result = deleteR(node.right, key)
        end
      end
      return fixup(node), result
    end
    
    def delete_minR(node)
      return nil if node.left.nil?
      if ( !isred(node.left) && !isred(node.left.left) )
        node = move_red_left(node)
      end
      node.left = delete_minR(node.left)
      
      fixup(node)
    end
    
    def delete_maxR(node)
      if (isred(node.left))
        node = rotate_right(node)
      end
      return nil if node.right.nil?
      if ( !isred(node.right) && !isred(node.right.left) )
        node = move_red_right(node)
      end
      node.right = delete_maxR(node.right)
      
      fixup(node)
    end
    
    def getR(node, key)
      return nil if node.nil?
      case key <=> node.key
      when  0 then return node.value;
      when -1 then return getR(node.left, key)
      when  1 then return getR(node.right, key)
      end
    end
    
    def to_sR(x)
      s = "("
      x.left.nil? ? s << '(' : s << to_sR(x.left)
      s << "*" if isred(x)
      x.right.nil? ? s << ')' : s << to_sR(x.right)
      s + ')'
    end
    
    def heightR(node)
      return 0 if node.nil?
      
      node.height
    end
    
    def minR(node)
      return node.key if node.left.nil?
      
      minR(node.left)
    end
    
    def maxR(node)
      return node.key if node.right.nil?
      
      maxR(node.right)
    end
    
    def insert(node, key, value)
      if(node.nil?)
        return Node.new(key, value)
      end
      
      colorflip(node) if (isred(node.left) && isred(node.right))
      
      case key <=> node.key
      when  0 then node.value = value
      when -1 then node.left = insert(node.left, key, value)
      when  1 then node.right = insert(node.right, key, value)
      end
      
      node = rotate_left(node) if isred(node.right)
      node = rotate_right(node) if (isred(node.left) && isred(node.left.left))
      
      set_num_nodes(node)
    end
    
    def isred(node)
      return false if node.nil?
      
      node.color == :red
    end
    
    def rotate_left(node)
      x = node.right
      node.right = x.left
      x.left = set_num_nodes(node)
      x.color = x.left.color
      x.left.color = :red
                         
      set_num_nodes(x)
    end
    
    def rotate_right(node)
      x = node.left
      node.left = x.right
      x.right = set_num_nodes(node)
      x.color = x.right.color
      x.right.color = :red
      
      set_num_nodes(x);
    end
    
    def colorflip(node)
      node.color       = node.color == :red       ? :black : :red
      node.left.color  = node.left.color == :red  ? :black : :red
      node.right.color = node.right.color == :red ? :black : :red
    end
    
    def move_red_left(node)
      colorflip(node)
      if isred(node.right.left)
        node.right = rotate_right(node.right)
        node = rotate_left(node)
        colorflip(node)
      end
      node
    end
    
    def move_red_right(node)
      colorflip(node)
      if isred(node.left.left)
        node = rotate_right(node)
        colorflip(node)
      end
      node     
    end
    
    def fixup(node)
      node = rotate_left(node) if isred(node.right)
      node = rotate_right(node) if (isred(node.left) && isred(node.left.left))
      colorflip(node) if (isred(node.left) && isred(node.right))
      
      set_num_nodes(node)
    end
    
    def set_num_nodes(node)
      node.num_nodes = (node.left ? node.left.size : 0) + (node.right ? node.right.size : 0) + 1
      if heightR(node.left) > heightR(node.right)
        node.height = heightR(node.left) + 1
      else
        node.height = heightR(node.right) + 1
      end
      node
    end
  end
  
end