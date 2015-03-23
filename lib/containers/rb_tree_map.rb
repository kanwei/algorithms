require 'containers/stack'
# rdoc
#     A RBTreeMap is a map that is stored in sorted order based on the order of its keys. This ordering is
#     determined by applying the function <=> to compare the keys. No duplicate values for keys are allowed,
#     so duplicate values are overwritten.
#
#     A major advantage of RBTreeMap over a Hash is the fact that keys are stored in order and can thus be
#     iterated over in order. This is useful for many datasets.
#
#     The implementation is adapted from Robert Sedgewick's Left Leaning Red-Black Tree implementation,
#     which can be found at http://www.cs.princeton.edu/~rs/talks/LLRB/Java/RedBlackBST.java
#
#     Containers::RBTreeMap automatically uses the faster C implementation if it was built
#     when the gem was installed. Alternatively, Containers::RubyRBTreeMap and Containers::CRBTreeMap can be
#     explicitly used as well; their functionality is identical.
#
#     Most methods have O(log n) complexity.
#
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
  alias []= push

  # Return the number of items in the TreeMap.
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.size #=> 2
  def size
    @root && @root.size || 0
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
    @root && @root.height || 0
  end

  # Return true if key is found in the TreeMap, false otherwise
  #
  # Complexity: O(log n)
  #
  #   map = Containers::TreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.key?("GA") #=> true
  #   map.key?("DE") #=> false
  def key?(key)
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
  alias [] get

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
    if @root
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

  # Deletes the item with the smallest key and returns the item. Returns nil
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
        if stack.empty?
          break
        else
          cursor = stack.pop
          yield(cursor.key, cursor.value)
          cursor = cursor.right
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
      @height = if left_height > right_height
                  left_height + 1
                else
                  right_height + 1
                end
      self
    end

    def rotate_left
      r = @right
      r_key = r.key
      r_value = r.value
      r_color = r.color
      b = r.left
      r.left = @left
      @left = r
      @right = r.right
      r.right = b
      r.color = :red
      r.key = @key
      r.value = @value
      @key = r_key
      @value = r_value
      r.update_size
      update_size
    end

    def rotate_right
      l = @left
      l_key = l.key
      l_value = l.value
      l_color = l.color
      b = l.right
      l.right = @right
      @right = l
      @left = l.left
      l.left = b
      l.color = :red
      l.key = @key
      l.value = @value
      @key = l_key
      @value = l_value
      l.update_size
      update_size
    end

    def move_red_left
      colorflip
      if @right.left && @right.left.red?
        @right.rotate_right
        rotate_left
        colorflip
      end
      self
    end

    def move_red_right
      colorflip
      if @left.left && @left.left.red?
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
      node.move_red_left if !isred(node.left) && !isred(node.left.left)
      node.left, result = delete_recursive(node.left, key)
    else
      node.rotate_right if isred(node.left)
      return nil, node.value if (key <=> node.key).zero? && node.right.nil?
      node.move_red_right if !isred(node.right) && !isred(node.right.left)
      if (key <=> node.key).zero?
        result = node.value
        node.value = get_recursive(node.right, min_recursive(node.right))
        node.key = min_recursive(node.right)
        node.right = delete_min_recursive(node.right).first
      else
        node.right, result = delete_recursive(node.right, key)
      end
    end
    [node.fixup, result]
  end
  private :delete_recursive

  def delete_min_recursive(node)
    return nil, node.value if node.left.nil?
    node.move_red_left if !isred(node.left) && !isred(node.left.left)
    node.left, result = delete_min_recursive(node.left)

    [node.fixup, result]
  end
  private :delete_min_recursive

  def delete_max_recursive(node)
    node = node.rotate_right if isred(node.left)
    return nil, node.value if node.right.nil?
    node.move_red_right if !isred(node.right) && !isred(node.right.left)
    node.right, result = delete_max_recursive(node.right)

    [node.fixup, result]
  end
  private :delete_max_recursive

  def get_recursive(node, key)
    return nil if node.nil?
    case key <=> node.key
    when 0 then return node.value
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
    when 0 then node.value = value
    when -1 then node.left = insert(node.left, key, value)
    when  1 then node.right = insert(node.right, key, value)
    end

    node.rotate_left if node.right && node.right.red?
    node.rotate_right if node.left && node.left.red? && node.left.left && node.left.left.red?
    node.colorflip if node.left && node.left.red? && node.right && node.right.red?
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
