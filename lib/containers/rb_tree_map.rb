module Containers
=begin rdoc
    A RBTreeMap is a map that is stored in sorted order based on the order of its keys. This ordering is
    determined by applying the function <=> to compare the keys. No duplicate values for keys are allowed,
    so duplicate values are overwritten.
    
    A major advantage of RBTreeMap over a Hash is the fact that keys are stored in order and can thus be
    iterated over in order. This is useful for many datasets.
    
    The implementation is adapted from Robert Sedgewick's Left Leaning Red-Black Tree implementation,
    which can be found at http://www.cs.princeton.edu/~rs/talks/LLRB/Java/RedBlackBST.java
    
    Containers::RBTreeMap automatically uses the faster C implementation if it was built 
    when the gem was installed. Alternatively, Containers::RubyRBTreeMap and Containers::CRBTreeMap can be 
    explicitly used as well; their functionality is identical.
    
=end
  class RubyRBTreeMap
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
      return 0 if @root.nil?
      @root.height
    end
    
    # Return true if key is found in the TreeMap, false otherwise
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.has_key?("GA") #=> true
    # map.has_key?("DE") #=> false
    def has_key?(key)
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
        @root.color = :black if @root
      end
      result
    end
    
    # Returns true if the tree is empty, false otherwise
    def empty?
      @root.nil?
    end
    
    # Deletes the item with the smallest key and returns the item. Returns nil
    # if key is not present.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.delete_min #=> "Massachusetts"
    # map.size #=> 1
    def delete_min
      result = nil
      if @root
        @root, result = delete_minR(@root)
        @root.color = :black if @root
      end
      result
    end
    
    # Deletes the item with the smallest key and returns the item. Returns nil
    # if key is not present.
    #
    # map = Containers::TreeMap.new
    # map.put("MA", "Massachusetts")
    # map.put("GA", "Georgia")
    # map.delete_max #=> "Georgia"
    # map.size #=> 1
    def delete_max
      result = nil
      if @root
        @root, result = delete_maxR(@root)
        @root.color = :black if @root
      end
      result
    end
    
    # Iterates over the TreeMap from smallest to largest element
    def each(&block)
      @root.nil? ? nil : eachR(@root, block)
    end
    
    private
    
    class Node # :nodoc: all
      attr_accessor :color, :key, :value, :left, :right, :size, :height
      def initialize(key, value)
        @key = key
        @value = value
        @color = :red
        @left = nil
        @right = nil
        @size = 1
        @height = 1
      end
      
      def red?
        @color == :red
      end
      
      def colorflip
        @color       = @color == :red       ? :black : :red
        @left.color  = @left.color == :red  ? :black : :red
        @right.color = @right.color == :red ? :black : :red
      end
      
      def update_size
        @size = (@left ? @left.size : 0) + (@right ? @right.size : 0) + 1
        left_height = (@left ? @left.height : 0)
        right_height = (@right ? @right.height : 0)
        if left_height > right_height
          @height = left_height + 1
        else
          @height = right_height + 1
        end
        self
      end
      
      def rotate_left
        r = @right
        r_key, r_value, r_color = r.key, r.value, r.color
        b = r.left
        r.left = @left
        @left = r
        @right = r.right
        r.right = b
        r.color, r.key, r.value = :red, @key, @value
        @key, @value = r_key, r_value
        r.update_size
        update_size
      end
      
      def rotate_right
        l = @left
        l_key, l_value, l_color = l.key, l.value, l.color
        b = l.right
        l.right = @right
        @right = l
        @left = l.left
        l.left = b
        l.color, l.key, l.value = :red, @key, @value
        @key, @value = l_key, l_value
        l.update_size
        update_size
      end
      
      def move_red_left
        colorflip
        if (@right.left && @right.left.red?)
          @right.rotate_right
          rotate_left
          colorflip
        end
        self
      end

      def move_red_right
        colorflip
        if (@left.left && @left.left.red?)
          rotate_right
          colorflip
        end
        self
      end
      
      def fixup
        rotate_left if @right && @right.red?
        rotate_right if (@left && @left.red?) && (@left.left && @left.left.red?)
        colorflip if (@left && @left.red?) && (@right && @right.red?)

        update_size
      end
    end
    
    def eachR(node, block)
      return if node.nil?
      
      eachR(node.left, block)
      block[node.key, node.value]
      eachR(node.right, block)
    end
    
    def deleteR(node, key)
      if (key <=> node.key) == -1
        node.move_red_left if ( !isred(node.left) && !isred(node.left.left) )
        node.left, result = deleteR(node.left, key)
      else
        node.rotate_right if isred(node.left)
        if ( ( (key <=> node.key) == 0) && node.right.nil? )
          return nil, node.value
        end
        if ( !isred(node.right) && !isred(node.right.left) )
          node.move_red_right
        end
        if (key <=> node.key) == 0
          result = node.value
          node.value = getR(node.right, minR(node.right))
          node.key = minR(node.right)
          node.right = delete_minR(node.right).first
        else
          node.right, result = deleteR(node.right, key)
        end
      end
      return node.fixup, result
    end
    
    def delete_minR(node)
      if node.left.nil?
        return nil, node.value 
      end
      if ( !isred(node.left) && !isred(node.left.left) )
        node.move_red_left
      end
      node.left, result = delete_minR(node.left)
      
      return node.fixup, result
    end
    
    def delete_maxR(node)
      if (isred(node.left))
        node = node.rotate_right
      end
      return nil, node.value if node.right.nil?
      if ( !isred(node.right) && !isred(node.right.left) )
        node.move_red_right
      end
      node.right, result = delete_maxR(node.right)
      
      return node.fixup, result
    end
    
    def getR(node, key)
      return nil if node.nil?
      case key <=> node.key
      when  0 then return node.value
      when -1 then return getR(node.left, key)
      when  1 then return getR(node.right, key)
      end
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
      
      node.colorflip if (node.left && node.left.red? && node.right && node.right.red?)
      
      case key <=> node.key
      when  0 then node.value = value
      when -1 then node.left = insert(node.left, key, value)
      when  1 then node.right = insert(node.right, key, value)
      end
      
      node.rotate_left if (node.right && node.right.red?)
      node = node.rotate_right if (node.left && node.left.red? && node.left.left && node.left.left.red?)
      
      node.update_size
    end
    
    def isred(node)
      return false if node.nil?
      
      node.color == :red
    end

  end
  
end