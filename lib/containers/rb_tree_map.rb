require 'containers/stack'
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
    
    Most methods have O(log n) complexity.

=end
class Containers::RubyRBTreeMap
  include Enumerable
  
  attr_accessor :height_black
  
  # Create and initialize a new empty TreeMap.
  def initialize
    @root = nil
    @height_black = 0
  end
  
  # Insert an item with an associated key into the TreeMap, and returns the item inserted
  #
  # Complexity: O(log n)
  #
  # map = Containers::TreeMap.new
  # map.push("MA", "Massachusetts") #=> "Massachusetts"
  # map.get("MA") #=> "Massachusetts"
  def push(key, value)
    @root = insert(@root, key, value)
    @height_black += 1 if isred(@root)
    @root.color = :black
    value
  end
  alias_method :[]=, :push
  
  # Return the number of items in the TreeMap.
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.size #=> 2
  def size
    @root and @root.size or 0
  end
  
  # Return the height of the tree structure in the TreeMap.
  #
  # Complexity: O(1)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.height #=> 2
  def height
    @root and @root.height or 0
  end
  
  # Return true if key is found in the TreeMap, false otherwise
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.has_key?("GA") #=> true
  #   map.has_key?("DE") #=> false
  def has_key?(key)
    !get(key).nil?
  end
  
  # Return the item associated with the key, or nil if none found.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.get("GA") #=> "Georgia"
  def get(key)
    get_recursive(@root, key)
  end
  alias_method :[], :get
  
  # Return the smallest key in the map.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.min_key #=> "GA"
  def min_key
    @root.nil? ? nil : min_recursive(@root)
  end
  
  # Return the largest key in the map.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.max_key #=> "MA"
  def max_key
    @root.nil? ? nil : max_recursive(@root)
  end
  
  # Deletes the item and key if it's found, and returns the item. Returns nil
  # if key is not present.
  #
  # !!! Warning !!! There is a currently a bug in the delete method that occurs rarely
  # but often enough, especially in large datasets. It is currently under investigation.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.min_key #=> "GA"
  def delete(key)
    result = nil
    if @root && get(key)
      @root, result = delete_recursive(@root, key)
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
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.delete_min #=> "Massachusetts"
  #   map.size #=> 1
  def delete_min
    result = nil
    if @root
      @root, result = delete_min_recursive(@root)
      @root.color = :black if @root
    end
    result
  end
  
  # Deletes the item with the largest key and returns the item. Returns nil
  # if key is not present.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.delete_max #=> "Georgia"
  #   map.size #=> 1
  def delete_max
    result = nil
    if @root
      @root, result = delete_max_recursive(@root)
      @root.color = :black if @root
    end
    result
  end
  
  # Iterates over the TreeMap from smallest to largest element. Iterative approach.
  def each
    return nil unless @root
    stack = Containers::Stack.new
    cursor = @root
    loop do
      if cursor
        stack.push(cursor)
        cursor = cursor.left
      else
        unless stack.empty?
          cursor = stack.pop
          yield(cursor.key, cursor.value)
          cursor = cursor.right
        else
          break
        end
      end
    end
  end
  
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

  def delete_recursive(node, key)
    if (key <=> node.key) == -1
      node.move_red_left if ( !isred(node.left) && !isred(node.left.left) )
      node.left, result = delete_recursive(node.left, key)
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
        node.value = get_recursive(node.right, min_recursive(node.right))
        node.key = min_recursive(node.right)
        node.right = delete_min_recursive(node.right).first
      else
        node.right, result = delete_recursive(node.right, key)
      end
    end
    return node.fixup, result
  end
  private :delete_recursive
  
  def delete_min_recursive(node)
    if node.left.nil?
      return nil, node.value 
    end
    if ( !isred(node.left) && !isred(node.left.left) )
      node.move_red_left
    end
    node.left, result = delete_min_recursive(node.left)
    
    return node.fixup, result
  end
  private :delete_min_recursive
  
  def delete_max_recursive(node)
    if (isred(node.left))
      node = node.rotate_right
    end
    return nil, node.value if node.right.nil?
    if ( !isred(node.right) && !isred(node.right.left) )
      node.move_red_right
    end
    node.right, result = delete_max_recursive(node.right)
    
    return node.fixup, result
  end
  private :delete_max_recursive
  
  def get_recursive(node, key)
    return nil if node.nil?
    case key <=> node.key
    when  0 then return node.value
    when -1 then return get_recursive(node.left, key)
    when  1 then return get_recursive(node.right, key)
    end
  end
  private :get_recursive
  
  def min_recursive(node)
    return node.key if node.left.nil?
    
    min_recursive(node.left)
  end
  private :min_recursive
  
  def max_recursive(node)
    return node.key if node.right.nil?
    
    max_recursive(node.right)
  end
  private :max_recursive
  
  def insert(node, key, value)
    return Node.new(key, value) unless node

    case key <=> node.key
    when  0 then node.value = value
    when -1 then node.left = insert(node.left, key, value)
    when  1 then node.right = insert(node.right, key, value)
    end
    
    node.rotate_left if (node.right && node.right.red?)
    node.rotate_right if (node.left && node.left.red? && node.left.left && node.left.left.red?)
    node.colorflip if (node.left && node.left.red? && node.right && node.right.red?)
    node.update_size
  end
  private :insert
  
  def isred(node)
    return false if node.nil?
    
    node.color == :red
  end
  private :isred
end

begin
  require 'CRBTreeMap'
  Containers::RBTreeMap = Containers::CRBTreeMap
rescue LoadError # C Version could not be found, try ruby version
  Containers::RBTreeMap = Containers::RubyRBTreeMap
end