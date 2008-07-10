module Containers
=begin rdoc
    A Trie is a data structure that stores key value pairs in a tree-like fashion. It allows
    O(m) lookup speed, where m is the length of the key searched, and has no chance of collisions,
    unlike hash tables. Because of its nature, search misses are quickly detected.
    
    Tries are often used for longest prefix algorithms, wildcard matching, and can be used to
    implement a radix sort.

    This implemention is based on a Ternary Search Tree.
=end
  class Trie
    
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
    #   t = Containers::Trie.new
    #   t["hello"] = "world"
    #   t.push("hello", "world") # does the same thing
    #   t["hello"] #=> "world"
    #   t[1] = 1
    #   t[1] #=> 1
    def push(key, value)
      key = key.to_s
      return nil if key.empty?
      @root = pushR(@root, key, 0, value)
      value
    end
    alias :[]= :push
    
    # Returns true if the key is contained in the Trie.
    def has_key?(key)
      key = key.to_s
      return false if key.empty?
      !(getR(@root, key, 0).nil?)
    end
    
    # Returns the value of the desired key, or nil if the key doesn't exist.
    #
    #   t = Containers::Trie.new
    #   t.get("hello") = "world"
    #   t.get("non-existant") #=> nil
    def get(key)
      key = key.to_s
      return nil if key.empty?
      node = getR(@root, key, 0)
      node ? node.last : nil
    end
    alias :[] :get
    
    # Returns the longest key that has a prefix in common with the parameter string. If
    # no match is found, the blank string "" is returned.
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
      len = prefixR(@root, string, 0)
      string[0...len]
    end
    
    # Returns a sorted array containing strings that match the parameter string. The wildcard
    # characters that match any character are '*' and '.' If no match is found, an empty
    # array is returned.
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
      ary << wildcardR(@root, string, 0, "")
      ary.flatten.compact.sort
    end
    
    private
    
    class Node # :nodoc: all
      attr_accessor :left, :mid, :right, :char, :value, :end
      
      def initialize(char, value)
        @char = char
        @value = value
        @left = @mid = @right = nil
        @end = false
      end
      
      def end?
        @end == true
      end
    end
    
    def wildcardR(node, string, index, prefix)
      return nil if node.nil? || index == string.length
      arr = []
      char = string[index]
      if (char.chr == "*" || char.chr == "." || char < node.char)
        arr << wildcardR(node.left, string, index, prefix)
      end
      if (char.chr == "*" || char.chr == "." || char > node.char)
        arr << wildcardR(node.right, string, index, prefix)
      end
      if (char.chr == "*" || char.chr == "." || char == node.char)
        arr << "#{prefix}#{node.char.chr}" if node.end?
        arr << wildcardR(node.mid, string, index+1, prefix + node.char.chr)
      end
      arr
    end
    
    def prefixR(node, string, index)
      return 0 if node.nil? || index == string.length
      len = 0
      rec_len = 0
      char = string[index]
      if (char < node.char)
        rec_len = prefixR(node.left, string, index)
      elsif (char > node.char)
        rec_len = prefixR(node.right, string, index)
      else
        len = index+1 if node.end?
        rec_len = prefixR(node.mid, string, index+1)
      end
      len > rec_len ? len : rec_len
    end
    
    def pushR(node, string, index, value)
      char = string[index]
      node = Node.new(char, value) if node.nil?
      if (char < node.char)
        node.left = pushR(node.left, string, index, value)
      elsif (char > node.char)
        node.right = pushR(node.right, string, index, value)
      elsif (index < string.length-1) # We're not at the end of the input string; add next char
        node.mid = pushR(node.mid, string, index+1, value)
      else
        node.end = true
        node.value = value
      end
      node
    end
    
    # Returns [char, value] if found
    def getR(node, string, index)
      return nil if node.nil?
      char = string[index]
      if (char < node.char)
        return getR(node.left, string, index)
      elsif (char > node.char)
        return getR(node.right, string, index)
      elsif (index < string.length-1) # We're not at the end of the input string; add next char
        return getR(node.mid, string, index+1)
      else
        return node.end? ? [node.char, node.value] : nil
      end
    end
  end
end