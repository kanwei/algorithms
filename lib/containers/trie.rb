=begin rdoc
    A Trie is a data structure that stores key value pairs in a tree-like fashion. It allows
    O(m) lookup speed, where m is the length of the key searched, and has no chance of collisions,
    unlike hash tables. Because of its nature, search misses are quickly detected.
    
    Tries are often used for longest prefix algorithms, wildcard matching, and can be used to
    implement a radix sort.

    This implemention is based on a Ternary Search Tree.
=end
class Containers::Trie  
  # Create a new, empty Trie.
  #
  #   t = Containers::Trie.new
  #   t["hello"] = "world"
  #   t["hello] #=> "world"
  def initialize
    @root = nil
  end
  
  # Adds a key, value pair to the Trie, and returns the value if successful. The to_s method is
  # called on the parameter to turn it into a string.
  #
  # Complexity: O(m)
  #
  #   t = Containers::Trie.new
  #   t["hello"] = "world"
  #   t.push("hello", "world") # does the same thing
  #   t["hello"] #=> "world"
  #   t[1] = 1
  #   t[1] #=> 1
  def push(key, value)
    key = key.to_s
    return nil if key.empty?
    @root = push_recursive(@root, key, 0, value)
    value
  end
  alias_method :[]=, :push
  
  # Returns true if the key is contained in the Trie.
  #
  # Complexity: O(m) worst case
  #
  def has_key?(key)
    key = key.to_s
    return false if key.empty?
    !(get_recursive(@root, key, 0).nil?)
  end
  
  # Returns the value of the desired key, or nil if the key doesn't exist.
  #
  # Complexity: O(m) worst case
  #
  #   t = Containers::Trie.new
  #   t.get("hello") = "world"
  #   t.get("non-existant") #=> nil
  def get(key)
    key = key.to_s
    return nil if key.empty?
    node = get_recursive(@root, key, 0)
    node ? node.last : nil
  end
  alias_method :[], :get
  
  # Returns the longest key that has a prefix in common with the parameter string. If
  # no match is found, the blank string "" is returned.
  #
  # Complexity: O(m) worst case
  #
  #   t = Containers::Trie.new
  #   t.push("Hello", "World")
  #   t.push("Hello, brother", "World")
  #   t.push("Hello, bob", "World")
  #   t.longest_prefix("Hello, brandon") #=> "Hello"
  #   t.longest_prefix("Hel") #=> ""
  #   t.longest_prefix("Hello") #=> "Hello"
  def longest_prefix(string)
    string = string.to_s
    return nil if string.empty?
    len = prefix_recursive(@root, string, 0)
    string[0...len]
  end
  
  # Returns a sorted array containing strings that match the parameter string. The wildcard
  # characters that match any character are '*' and '.' If no match is found, an empty
  # array is returned.
  #
  # Complexity: O(n) worst case
  #
  #   t = Containers::Trie.new
  #   t.push("Hello", "World")
  #   t.push("Hilly", "World")
  #   t.push("Hello, bob", "World")
  #   t.wildcard("H*ll.") #=> ["Hello", "Hilly"]
  #   t.wildcard("Hel") #=> []
  def wildcard(string)
    string = string.to_s
    return nil if string.empty?
    ary = [] 
    ary << wildcard_recursive(@root, string, 0, "")
    ary.flatten.compact.sort
  end

  class Node # :nodoc: all
    attr_accessor :left, :mid, :right, :char, :value, :end
    
    def initialize(char, value)
      @char = char
      @value = value
      @left = @mid = @right = nil
      @end = false
    end
    
    def last?
      @end == true
    end
  end
  
  def wildcard_recursive(node, string, index, prefix)
    return nil if node.nil? || index == string.length
    arr = []
    char = string[index]
    if (char.chr == "*" || char.chr == "." || char < node.char)
      arr << wildcard_recursive(node.left, string, index, prefix)
    end
    if (char.chr == "*" || char.chr == "." || char > node.char)
      arr << wildcard_recursive(node.right, string, index, prefix)
    end
    if (char.chr == "*" || char.chr == "." || char == node.char)
      arr << "#{prefix}#{node.char.chr}" if node.last?
      arr << wildcard_recursive(node.mid, string, index+1, prefix + node.char.chr)
    end
    arr
  end
  
  def prefix_recursive(node, string, index)
    return 0 if node.nil? || index == string.length
    len = 0
    rec_len = 0
    char = string[index]
    if (char < node.char)
      rec_len = prefix_recursive(node.left, string, index)
    elsif (char > node.char)
      rec_len = prefix_recursive(node.right, string, index)
    else
      len = index+1 if node.last?
      rec_len = prefix_recursive(node.mid, string, index+1)
    end
    len > rec_len ? len : rec_len
  end
  
  def push_recursive(node, string, index, value)
    char = string[index]
    node = Node.new(char, value) if node.nil?
    if (char < node.char)
      node.left = push_recursive(node.left, string, index, value)
    elsif (char > node.char)
      node.right = push_recursive(node.right, string, index, value)
    elsif (index < string.length-1) # We're not at the end of the input string; add next char
      node.mid = push_recursive(node.mid, string, index+1, value)
    else
      node.end = true
      node.value = value
    end
    node
  end
  
  # Returns [char, value] if found
  def get_recursive(node, string, index)
    return nil if node.nil?
    char = string[index]
    if (char < node.char)
      return get_recursive(node.left, string, index)
    elsif (char > node.char)
      return get_recursive(node.right, string, index)
    elsif (index < string.length-1) # We're not at the end of the input string; add next char
      return get_recursive(node.mid, string, index+1)
    else
      return node.last? ? [node.char, node.value] : nil
    end
  end
end