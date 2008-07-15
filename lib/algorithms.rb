=begin rdoc
  The 'Algorithms and Containers' library is an effort to provide a set of commonly used
  algorithms and containers to Ruby programmers.

  To avoid typing Containers::xxx to initialize containers, include the Containers module.
    
    require 'algorithms'
    include Containers
    
    tree = RBTreeMap.new
  
  Done so far:
  * Heaps (Maximum, Minimum)
  * Priority Queue
  * Stack
  * Queue
  * Deque
  * Red-Black Trees
  * Splay Trees
  * Tries (Ternary Search Tree)
  * Suffix Array

  Upcoming:
  * Graphs, graph algorithms
  * Search algorithms
  * Sort algorithms
  * String algorithms    
=end

module Containers; end

require 'containers/heap'
require 'containers/stack'
require 'containers/deque'
require 'containers/queue'
require 'containers/priority_queue'
require 'containers/rb_tree_map'
require 'containers/splay_tree_map'
require 'containers/suffix_array'
require 'containers/trie'