require 'containers/stack'
=begin rdoc
    A SplayTreeMap is a map that is stored in ascending order of its keys, determined by applying
    the function <=> to compare keys. No duplicate values for keys are allowed, so new values of a key
    overwrites the old value of the key.
    
    A major advantage of SplayTreeMap over a Hash is the fact that keys are stored in order and can thus be
    iterated over in order. Also, Splay Trees are self-optimizing as recently accessed nodes stay near
    the root and are easily re-accessed later. Splay Trees are also more simply implemented than Red-Black
    trees.
    
    Splay trees have amortized O(log n) performance for most methods, but are O(n) worst case. This happens
    when keys are added in sorted order, causing the tree to have a height of the number of items added.
    
=end
class Containers::RubySplayTreeMap
  include Enumerable
  
  Node = Struct.new(:key, :value, :left, :right)
  
  # Create and initialize a new empty SplayTreeMap.
  def initialize
    @size = 0
    clear
  end
  
  # Insert an item with an associated key into the SplayTreeMap, and returns the item inserted
  #
  # Complexity: amortized O(log n)
  #
  #   map = Containers::SplayTreeMap.new
  #   map.push("MA", "Massachusetts") #=> "Massachusetts"
  #   map.get("MA") #=> "Massachusetts"
  def push(key, value)
    if @root.nil?
      @root = Node.new(key, value, nil, nil)
      @size = 1
      return value
    end
    splay(key)
    
    cmp = (key <=> @root.key)
    if cmp == 0
      @root.value = value
      return value
    end
    node = Node.new(key, value, nil, nil)
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
  alias_method :[]=, :push
  
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
  #
  # Complexity: O(1)
  #
  def clear
    @root = nil
    @size = 0
    @header = Node.new(nil, nil, nil, nil)
  end
  
  # Return the height of the tree structure in the SplayTreeMap.
  #
  # Complexity: O(log n)
  #
  #   map = Containers::SplayTreeMap.new
  #   map.push("MA", "Massachusetts")
  #   map.push("GA", "Georgia")
  #   map.height #=> 2
  def height
    height_recursive(@root)
  end
  
  # Return true if key is found in the SplayTreeMap, false otherwise.
  #
  # Complexity: amortized O(log n)
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
  # Complexity: amortized O(log n)
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
  alias_method :[], :get
  
  # Return the smallest [key, value] pair in the SplayTreeMap, or nil if the tree is empty.
  #
  # Complexity: amortized O(log n)
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
  # Complexity: amortized O(log n)
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
  # Complexity: amortized O(log n)
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
  
  # Iterates over the SplayTreeMap in ascending order. Uses an iterative, not recursive, approach.
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
  private :splay
  
  # Recursively determine height
  def height_recursive(node)
    return 0 if node.nil?
    
    left_height   = 1 + height_recursive(node.left)
    right_height  = 1 + height_recursive(node.right)
    
    left_height > right_height ? left_height : right_height
  end
  private :height_recursive
end

begin
  require 'CSplayTreeMap'
  Containers::SplayTreeMap = Containers::CSplayTreeMap
rescue LoadError # C Version could not be found, try ruby version
  Containers::SplayTreeMap = Containers::RubySplayTreeMap
end
