=== April 15, 2012

    * Use long instead of int for string methods
    * Use VALUE instead of int for comparison vars
    * Now compiles without warnings (OS X 10.7)

=== April 19, 2012

    * Pulled in fix for ruby 1.9 compilation error (sorry!!)
    * Fix specs that broke with new rspec
    * Migration to rubygems.org
    * 0.4.0 release

=== Jan 3, 2009

    * Levenshtein distance in C

=== April 3, 2009

	* Finished C refactorization of SplayTree

=== March 28, 2009

	* Implemented SplayTree in C
	* Made recursively_free_nodes methods static to fix a SEGFAULT
	* Improved CBst
	* Moved to Markdown for README
	* 0.2.0 release

=== January 19, 2009

  * kd-tree for points in multi-dimensional space

=== November 25, 2008

  * Checked in gnufied's C BST
  
=== November 13, 2008

  * Removed #each for Hash and Priority Queue (Feature)
  
=== September 15, 2008

  * Added comb sort
  * Benchmark work on sorting algorithms

=== September 1, 2008

  * Switched to Hanna rdoc template
  * RBTree#isred now private

=== August 20, 2008

  * Implemented Knuth-Morris-Pratt substring algorithm
  
=== August 15, 2008

  * Updated README to reflect progress

=== August 10, 2008

  * Implemented mergesort, insertion_sort, shell_sort, quicksort

=== August 8, 2008

  * Implemented bubble_sort, selection_sort, heapsort

=== August 5, 2008

  * Started Algorithms portion
  * Implemented Search#binary_search

=== July 20, 2008

  * Iterate over trees iteratively instead of recursively
  * Implemented Deque in C

=== July 15, 2008

  * Refactored namespaces, thank you Austin Ziegler!

=== July 14, 2008

  * Use alias_method instead of alias
  * Found and fixed RBTree#delete bug (finally!)
  * Refactored Trie, SuffixArray, SplayTreeMap

=== July 13, 2008

  * Refactored Deque
  * Implemented Deque#reverse_each (like Array's)

=== July 12, 2008

  * Reformatted some specs to be more idiomatic (Thank you Federico Builes)

=== July 10, 2008

  * Added algorithm complexity information for all Containers
  * Implemented Trie for string representation
  * Implmented SuffixArray for fast substring search
  * Fixed memory leak in CRBTree
  * Updated Manifest and algorithms.rb to match progress

=== July 9, 2008

  * Implemented Deque
  * Stack and Queue now use Deque
  * Fixed issues with CRBTree's #empty? and delete methods

=== July 8, 2008

  * Can now iterate over a heap
  * Renamed #contains_key -> has_key? since it's more idiomatic
  * Implented #change_key and #delete for Heap
  * Priority Queue is now implemented with the new Fibonacci Heap
  * Removed old Priority Queue code as a result
  * Heap: fixed #delete bug not checking if item exists, #has_key? bug 
          for not returning boolean
  * Heap: value field is now optional and defaults to the key if not specified
  * More refactoring of RBTreeMap (both Ruby and C)
  
=== July 7, 2008

  * Heap is now implemented with a Fibonacci Heap, not a binomial heap

=== July 4, 2008

  * Implemented SplayTreeMap
  * Heap now uses kind_of? to check for other heaps when doing #merge
  * Renamed some Heap methods for consistency with the rest of the library
  * RBTreeMap#contains? -> contains_key?
  * Refactored RBTreeMap to be more object-oriented
  * More documentation for RBTreeMap

=== July 3, 2008
  
  * Added documentation for Stack and Queue

=== June 24, 2008
  
  * Imported Brian Amberg's priority queue implementation
  * Now uses Echoe to build gem
  * Gem builds for the first time

=== June 18, 2008
  
  * Can now enumerate over RBTreeMap

=== June 17, 2008

  * RBTreemap#delete now returns deleted value
  * Added delete method to C implementation

=== June 16, 2008

  * Implemented delete methods for RBTreeMap

=== June 14, 2008

  * Renamed the data structures module to "Containers"
  * Removed dependence on stdbool.h
  * Renamed RBTree to RBTreeMap

=== June 13, 2008

  * Implemented Sedgewick's Left Leaning Red Black Tree in C!

=== June 12, 2008

  * Implemented Sedgewick's Left Leaning Red Black Tree

=== June 10, 2008

  * Implemented merge! for other heaps and heap initialization from an array
  * Implemented Queue

=== June 9, 2008

  * Finished binomial heap implementation

=== June 8, 2008

  * Added Stack
  * Working on heap

=== April 20

  * Accepted to Google Summer of Code!