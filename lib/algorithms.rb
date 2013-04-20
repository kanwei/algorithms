=begin rdoc
  The 'Algorithms and Containers' library is an effort to provide a set of commonly used
  algorithms and containers to Ruby programmers.

  This is a Google Summer of Code 2008 project

  Written by Kanwei Li, mentored by Austin Ziegler

  To avoid typing Containers::xxx to initialize containers, include the Containers module.

    require 'algorithms'
    include Containers

    tree = RBTreeMap.new

  instead of:

    require 'algorithms'

    tree = Containers::RBTreeMap.new

  Done so far:
  * Heaps           - Containers::Heap, Containers::MaxHeap, Containers::MinHeap
  * Priority Queue  - Containers::PriorityQueue
  * Stack           - Containers::Stack
  * Queue           - Containers::Queue
  * Deque           - Containers::Deque, Containers::CDeque (C extension), Containers::RubyDeque
  * Red-Black Trees - Containers::RBTreeMap, Containers::CRBTreeMap (C extension), Containers::RubyRBTreeMap
  * Splay Trees     - Containers::SplayTreeMap
  * Tries           - Containers::Trie
  * Suffix Array    - Containers::SuffixArray
  * kd Tree         - Containers::KDTree

  * Search algorithms
    - Binary Search         - Algorithms::Search.binary_search
    - Knuth-Morris-Pratt    - Algorithms::Search.kmp_search
  * Sort algorithms
    - Bubble sort           - Algorithms::Sort.bubble_sort
    - Comb sort             - Algorithms::Sort.comb_sort
    - Selection sort        - Algorithms::Sort.selection_sort
    - Heapsort              - Algorithms::Sort.heapsort
    - Insertion sort        - Algorithms::Sort.insertion_sort
    - Shell sort            - Algorithms::Sort.shell_sort
    - Quicksort             - Algorithms::Sort.quicksort
    - Mergesort             - Algorithms::Sort.mergesort
    - Dual-Pivot Quicksort  - Algorithms::Sort.dualpivotquicksort
  * String algorithms
    - Levenshtein distance  - Algorithms::String.levenshtein_dist
=end

module Algorithms; end
module Containers; end

require 'algorithms/search'
require 'algorithms/sort'
require 'algorithms/string'
require 'containers/heap'
require 'containers/stack'
require 'containers/deque'
require 'containers/queue'
require 'containers/priority_queue'
require 'containers/rb_tree_map'
require 'containers/splay_tree_map'
require 'containers/suffix_array'
require 'containers/trie'
require 'containers/kd_tree'
