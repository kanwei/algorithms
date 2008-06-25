# This is a fibonacci heap priority queue implementation.
# (c) 2005 Brian Amberg
# Please submit bugreports to mail@brian-amberg.de

# Modifications by Kanwei Li
module Containers
  class RubyPriorityQueue
    include Enumerable
    
    # Returns the number of elements of the queue.
    # 
    #    q = PriorityQueue.new
    #    q.length #=> 0
    #    q[0] = 1
    #    q.length #=> 1
    attr_reader :length

    # Create a new, empty PriorityQueue
    def initialize
      @nodes = Hash.new
      @rootlist = nil
      @min = nil
      @length = 0
    end

    # Print a priority queue as a dot-graph. The output can be fed to dot from the
    # vizgraph suite to create a tree depicting the internal datastructure.
    def to_dot
      r = ["digraph fibheap {"]
      #r << @rootlist.to_dot.join("\n") if @rootlist
      r << "ROOT -> #{@rootlist.dot_id};" if @rootlist
      @nodes.to_a.sort.each do | (_, n) |
        r << "  #{n.dot_id} [label=\"#{n.key}: #{n.priority}\"];"
        r << "  #{n.dot_id} -> #{n.right.dot_id} [constraint=false];" if n.right# and n.dot_id < n.right.dot_id
        r << "  #{n.dot_id} -> #{n.left.dot_id} [constraint=false];" if n.left #and n.dot_id < n.left.dot_id
        r << "  #{n.dot_id} -> #{n.child.dot_id}" if n.child
      end
      r << "}"
      r.join("\n")
      r
    end

    # Call dot and gv displaying the datstructure
    def display_dot
      puts to_dot
      system "echo '#{to_dot}' | twopi -Tps -Groot=ROOT -Goverlap=false> /tmp/dotfile.ps; gv /tmp/dotfile.ps"
    end

    # call-seq:
    #     [key] = priority
    #     change_priority(key, priority)
    #     push(key, priority)
    # 
    # Set the priority of a key.
    #
    #     q = PriorityQueue.new
    #     q["car"] = 50
    #     q["train"] = 50
    #     q["bike"] = 10
    #     q.min #=> ["bike", 10]
    #     q["car"] = 0
    #     q.min #=> ["car", 0]
    def change_priority(key, priority)
      return push(key, priority) unless @nodes[key]

      n = @nodes[key]
      if n.priority < priority # Priority was increased. Remove the node and reinsert.
        self.delete(key)
        self.push(key, priority);
        return self
      end
      n.priority = priority;
      @min = n if n.priority < @min.priority

      return self if !n.parent or n.parent.priority <= n.priority # Already in rootlist or bigger than parent
      begin # Cascading Cuts
        p = n.parent
        cut_node(n)
        n = p
      end while n.mark and n.parent
      n.mark = true if n.parent

      self
    end

    # Add an object to the queue.
    def push(key, priority)    
      return change_priority(key, priority) if @nodes[key]
      @nodes[key] = node = Node.new(key, priority)
      @min = node if !@min or priority < @min.priority
      if not @rootlist
        @rootlist = node
        node.left = node.right = node
      else
        node.left = @rootlist.left
        node.right = @rootlist
        @rootlist.left.right = node
        @rootlist.left = node
      end
      @length += 1
      self
    end

    # Returns true if the array is empty, false otherwise.
    def empty?
      @rootlist.nil?
    end

    # call-seq:
    #     [key] -> priority
    #
    # Return the priority of a key or nil if the key is not in the queue.
    #
    #     q = PriorityQueue.new
    #     (0..10).each do | i | q[i.to_s] = i end
    #     q["5"] #=> 5
    #     q[5] #=> nil
    def [](key)
      @nodes[key] and @nodes[key].priority
    end

    # call-seq:
    #     has_key? key -> boolean
    #     
    # Return false if the key is not in the queue, true otherwise.
    #
    #     q = PriorityQueue.new
    #     (0..10).each do | i | q[i.to_s] = i end
    #     q.has_key("5") #=> true 
    #     q.has_key(5)   #=> false
    def has_key?(key)
      @nodes.has_key?(key)
    end

    alias :[]= :push

    # Call the given block with each [key, priority] pair in the queue
    #
    # Beware: Changing the queue in the block may lead to unwanted behaviour and
    # even infinite loops.
    def each
      @nodes.each do | key, node |
        yield(key, node.priority)
      end
    end

    # call-seq:
    #     min -> [object, priority]
    #    
    # Return the pair [object, priority] with minimal priority or nil when the
    # queue is empty.
    #
    #     q = PriorityQueue.new
    #     q["a"] = 10
    #     q["b"] = 20
    #     q.min          #=> ["a", 10]
    #     q.delete_min   #=> ["a", 10]
    #     q.min          #=> ["b", 20]
    #     q.delete_min   #=> ["b", 20]
    #     q.min          #=> nil
    def min
      [@min.key, @min.priority] rescue nil
    end

    # call-seq:
    #     min_key -> object
    #    
    # Return the key that has the minimal priority or nil when the queue is empty.
    #
    #     q = PriorityQueue.new
    #     q["a"] = 10
    #     q["b"] = 20
    #     q.min_key      #=> "a"
    #     q.delete_min   #=> ["a", 10]
    #     q.min_key      #=> "b"
    #     q.delete_min   #=> ["b", 20]
    #     q.min_key      #=> nil
    def min_key    
      @min.key rescue nil
    end

    # call-seq:
    #     min_priority -> priority
    #
    # Return the minimal priority or nil when the queue is empty.
    #
    #     q = PriorityQueue.new
    #     q["a"] = 10
    #     q["b"] = 20
    #     q.min_priority #=> 10
    #     q.delete_min   #=> ["a", 10]
    #     q.min_priority #=> 20
    #     q.delete_min   #=> ["b", 20]
    #     q.min_priority #=> nil
    def min_priority
      @min.priority rescue nil
    end

    # call-seq:
    #     delete(key) -> [key, priority]
    #     delete(key) -> nil
    #
    # Delete a key from the priority queue. Returns nil when the key was not in
    # the queue and [key, priority] otherwise.
    #
    #     q = PriorityQueue.new
    #     (0..10).each do | i | q[i.to_s] = i end
    #     q.delete(5)                              #=> ["5", 5]
    #     q.delete(5)                              #=> nil
    def delete(key)
      return nil unless n = @nodes.delete(key)

      if n.child 
        c = n.child
        e = n.child
        begin
          r = c.right
          cut_node(c)
          c = r
        end while c != e
      end
      cut_node(n) if n.parent

      if n == n.right 
        @min = nil;
        @rootlist = nil;
      else 
        @rootlist = n.right if @rootlist == n
        if @min == n
          n1 = n.right
          @min = n1
          begin
            @min = n1 if n1.priority < @min.priority
            n1 = n1.right
          end while(n1 != n);
        end
        n.right.left = n.left
        n.left.right = n.right
        n.left = n
        n.right = n
      end
      @length -= 1
      return [n.key, n.priority]
    end

    # call-seq:
    #    delete_min_return_key -> key
    #    
    # Delete key with minimal priority and return the key
    #
    #    q = PriorityQueue.new
    #    q["a"] = 1
    #    q["b"] = 0
    #    q.delete_min_return_key #=> "b"
    #    q.delete_min_return_key #=> "a"
    #    q.delete_min_return_key #=> nil
    def delete_min_return_key
      delete_min[0] rescue nil
    end

    # call-seq:
    #    delete_min_return_priority -> priority
    #    
    # Delete key with minimal priority and return the priority value
    #
    #    q = PriorityQueue.new
    #    q["a"] = 1
    #    q["b"] = 0
    #    q.delete_min_return_priority #=> 0
    #    q.delete_min_return_priority #=> 1
    #    q.delete_min_return_priority #=> nil
    def delete_min_return_priority
      delete_min[1] rescue nil
    end

    # call-seq:
    #    delete_min -> [key, priority]
    #    
    # Delete key with minimal priority and return [key, priority]
    #
    #    q = PriorityQueue.new
    #    q["a"] = 1
    #    q["b"] = 0
    #    q.delete_min #=> ["b", 0]
    #    q.delete_min #=> ["a", 1]
    #    q.delete_min #=> nil
    def delete_min
      return nil if self.empty?
      result = self.min

      @nodes.delete(@min.key)

      if @length == 1
        @rootlist = @min = nil
        @length = 0
      else 
        min = @min
        if @min == @rootlist # If the rootlist is anchored at the minimum, shift to the right
          if @rootlist == @rootlist.right 
            @rootlist = @min = nil
          else
            @rootlist = @min = @min.right
          end 
        end
        min.left.right = min.right;
        min.right.left = min.left;
        min.left = min.right = min;
        if min.child
          # Kinder und Eltern trennen, Markierung aufheben
          n = min.child;
          begin
            n.parent = nil;
            n.mark = false;
            n = n.right;
          end while n != min.child

          # Kinder einfügen
          if @rootlist
            l1 = @rootlist.left
            l2 = n.left

            l1.right = n
            n.left = l1
            l2.right = @rootlist
            @rootlist.left = l2
          else
            @rootlist = n
          end
        end

        # Größe anpassen
        @length -= 1

        # Wieder aufhübschen
        consolidate
      end

      result
    end

    # Returns a string representation of the priority queue.
    def inspect
      "<PriorityQueue: #{@nodes.map{|(_, n)| [n.key, n.priority]}.sort_by{|(_,p)|p}.inspect}>"
    end

    def initialize_copy(copy)
      copy_nodes = @nodes
      @nodes = {}

      copy_nodes.each do | (_, cn) |
        n = @nodes[cn.key] = Node.new(cn.key, cn.priority)
        n.mark = cn.mark
        n.degree = cn.degree
      end

      copy_nodes.each do | (_, cn) |
        n = @nodes[cn.key]
        n.left   = @nodes[cn.left.key]   if cn.left
        n.right  = @nodes[cn.right.key]  if cn.right
        n.parent = @nodes[cn.parent.key] if cn.parent
        n.child  = @nodes[cn.child.key]  if cn.child
      end
      @rootlist = @nodes[@rootlist.key] if @rootlist
      @min = @nodes[@min.key] if @min
      self
    end

    # Node class used internally
    class Node # :nodoc:
      attr_accessor :parent, :child, :left, :right, :key, :priority, :degree, :mark

      def child=(c)
        raise "Circular Child" if c == self
        raise "Child is neighbour" if c == self.right
        raise "Child is neighbour" if c == self.left
        @child = c
      end

      def to_dot(only_down = false, known_nodes = [])
        p known_nodes.map { | n | n.dot_id }
        p self.dot_id
        result = []
        if only_down
          raise "Circular #{caller.inspect}" if known_nodes.include?(self)
          known_nodes << self

          result << "#{dot_id} [label=\"#{@key}: #{@priority}\"];"
          l = "  "
          #l << "#{@left.dot_id} <- #{dot_id}; " if @left 
          l << "#{dot_id} -> #{@left.dot_id} [constraint=false]; " if @left and @left.dot_id < self.dot_id
          l << "#{dot_id} -> #{@right.dot_id} [constraint=false];\t\t\t\t/*neighbours*/" if @right and @right.dot_id <= self.dot_id
          result << l
          result << "  #{dot_id} -> #{@child.dot_id}; //child" if @child
          result << @child.to_dot(false, known_nodes) if @child
        else
          n = self
          begin
            result.concat(n.to_dot(true, known_nodes))
            n = n.right
          end while n != self
        end
        result.flatten.map{|r| "  " << r}
      end

      def dot_id
        "N#{@key}"
      end

      def initialize(key, priority)
        @key = key; @priority = priority; @degree = 0
      end
    end
    
    
    private

    def link_nodes(b1, b2)
      return link_nodes(b2, b1) if b2.priority < b1.priority

      b2.parent = b1    
      child = b1.child
      b1.child = b2
      if child 
        b2.left  = child.left
        b2.left.right = b2
        b2.right = child
        child.left = b2
      else 
        b2.left = b2
        b2.right = b2
      end
      b1.degree += 1
      b2.mark = false # TODO: Check if this is correct, or if b1 should be marked as false
      return b1
    end

    # Does not change length
    def delete_first
      return nil unless @rootlist

      result = @rootlist
      if result == result.right
        @min = @rootlist = nil
      else 
        @rootlist = result.right
        @rootlist.left = result.left
        @rootlist.left.right = @rootlist

        result.right = result.left = result      
      end
      return result;
    end

    def cut_node(n)
      return self unless n.parent
      n.parent.degree -= 1
      if n.parent.child == n 
        if n.right == n
          n.parent.child = nil
        else
          n.parent.child = n.right;  
        end
      end
      n.parent = nil
      n.right.left = n.left
      n.left.right = n.right

      n.right = @rootlist
      n.left  = @rootlist.left
      @rootlist.left.right = n
      @rootlist.left = n

      n.mark = false

      return self
    end

    # Does not change length
    def insert_tree(tree)
      if @rootlist == nil
        @rootlist = @min = tree
      else
        l = @rootlist.left
        l.right = tree
        @rootlist.left = tree
        tree.left = l
        tree.right = @rootlist
        @min = tree if tree.priority < @min.priority
      end
      self
    end

    def consolidate
      return self if self.empty?
      array_size = (2.0 * Math.log(self.length) / Math.log(2) + 1.0).ceil
      tree_by_degree = Array.new(array_size)

      while n = delete_first      
        while n1 = tree_by_degree[n.degree]	
          tree_by_degree[n.degree] = nil;
          n = link_nodes(n, n1);
        end
        tree_by_degree[n.degree] = n;
      end

      @rootlist = @min = nil;
      tree_by_degree.each do | tree | 
        next unless tree
        insert_tree(tree)
      end
      self
    end
  end
end