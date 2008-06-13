class DS
  # A self-balancing red-black tree implementation
  # Adapted from Robert Sedgewick's Left Leaning Red-Black Tree Implementation
  # http://www.cs.princeton.edu/~rs/talks/LLRB/Java/RedBlackBST.java
  class RedBlackTree
    class Node
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
    end
    
    attr_accessor :height_black
    
    def initialize
      @root = nil
      @height_black = 0
    end
    
    def put(key, value)
      @root = insert(@root, key, value)
      @height_black += 1 if isred(@root)
      @root.color = :black
    end
    
    def size
      return sizeR(@root)
    end
    
    def height
      return heightR(@root)
    end
    
    def contains?(key)
      return !get(key).nil?
    end
    
    def get(key)
      return getR(@root, key)
    end
    
    def min
      return @root.nil? ? nil : minR(@root)
    end
    
    def max
      return @root.nil? ? nil : maxR(@root)
    end
    
    def to_s
      return "" if @root.nil?
      return "#{@height_black} #{to_sR(@root)}"
    end
    
    private
    
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
      return s + ')'
    end    
    
    def sizeR(node)
      return 0 if node.nil?
      return node.num_nodes
    end
    
    def heightR(node)
      return 0 if node.nil?
      return node.height
    end
    
    def minR(node)
      return node.key if node.left.nil?
      return minR(node.left)
    end
    
    def maxR(node)
      return node.key if node.right.nil?
      return maxR(node.right)
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
      
      return set_num_nodes(node)
    end
    
    def isred(h)
      return false if h.nil?
      return h.color == :red
    end
    
    def rotate_left(h)
      x = h.right;
      h.right = x.left;
      x.left = set_num_nodes(h);
      x.color = x.left.color;                   
      x.left.color = :red;                     
      return set_num_nodes(x);
    end
    
    def rotate_right(h)
      x = h.left;
      h.left = x.right;
      x.right = set_num_nodes(h);
      x.color = x.right.color;                   
      x.right.color = :red;                     
      return set_num_nodes(x);
    end
    
    def colorflip(h)
      h.color       = h.color == :red       ? :black : :red
      h.left.color  = h.left.color == :red  ? :black : :red
      h.right.color = h.right.color == :red ? :black : :red
    end
    
    def move_red_left(h)
      colorflip(h)
      if isred(h.right.left)
        h.right = rotate_right(h.right)
        h = rotate_left(h)
        colorflip(h)
      end
      return h      
    end
    
    def move_red_right(h)
      colorflip(h)
      if isred(h.left.left)
        h = rotate_right(h)
        colorflip(h)
      end
      return h      
    end
    
    def fixup(h)
      h = rotate_left(h) if isred(h.right)
      h = rotate_right(h) if (isred(h.left) && isred(h.left.left))
      colorflip(h) if (isred(h.left) && isred(h.right))
      return set_num_nodes(h)
    end
    
    def set_num_nodes(h)
      h.num_nodes = sizeR(h.left) + sizeR(h.right) + 1
      if heightR(h.left) > heightR(h.right)
        h.height = heightR(h.left) + 1
      else
        h.height = heightR(h.right) + 1
      end
      return h
    end
  end
  
  class SplayTree
    
  end
  
end