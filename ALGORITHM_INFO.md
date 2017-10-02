* Heaps

  * About - is a container satisfying the Heap Property
    * Example - Refer to lib/containers/heap.rb
    * Heap class's method complexities
      * Time Complexity: O(1) - push (insert new tree with single node, has_key?, next (of value), next_key,
               clear, empty?, merge (link two heaps), pop
      * Time Complexity: O(1) "amortized" - change_key (new key cannot violate Heap Property)
      * Time Complexity: O(log n) "amortized" - delete key
  * Min/Max Heap Property - where value of a node always smaller/larger than its parent node
  * MinHeap - smaller items are parent nodes
    * MinHeap class's method complexities
      * Time Complexity: O(V*logV+E) - min key (extract min most complex with delayed work consolidating trees)
  * MaxHeap - larger items are parent nodes
    * MaxHeap class's method complexities
      * Time Complexity: O(V*logV+E) - max key (same as for MinHeap)
  * MinMaxHeap - alternating larger/smaller items as parent nodes
    * Reference: https://en.wikipedia.org/wiki/Min-max_heap
  * Amortised -
    * Hash Tables O(1) lookup/insert performance (if qty elements stored ~= qty buckets)
      * Problem: Hash Tables O(n) lookup time (if qty elements stored >> qty buckets)
      * Solution: New Hash Table size insert and rehash elements (if qty elements ~> 2 * qty buckets)
        * O(n) time to insert n elements into empty array and resize (as some elements triggering rehashing)
        where insertion operation has O(1) "amortized" run time (average insertion time)
    * Reference: http://www.cs.cornell.edu/courses/cs3110/2011fa/supplemental/lec20-amortized/amortized.htm
  * Fibonacci Heap - allows O(1) (Constant Time for Lookup and Inserts) complexity for most methods
    * **Priority Queue** operations data structure
    * Fibonacci Heap used since Fibonacci numbers used in running Time Analysis
    * Fibonacci Heap nodes all have max degree of O(log n)
    * Fibonacci Heap subtree size for node of degree k is Fk+2 (where Fk is kth Fibonacci number)
    * Collection of Trees with MinHeap or MaxHeap Property
    * Faster than Binary Heap and Binomial Heap
    * Pointer to Tree Root (Min value)
    * All Tree Roots connected with Doubly Linked List
    * O(V*logV+E) - min key (extract min most complex with delayed work consolidating trees)
    * Fibonacci Heaps' reduced time complexity (running time) when used with:
    * Examples: **Dijkstra Graph Algorithm (Shortest Path)**
      * https://www.youtube.com/watch?v=8Ls1RqHCOPw
    * Examples: **Prim "Greedy" Minimum Spanning Tree (MST) Algorithm**
      * Least cost edges selected but no cycles allowed
      * https://www.youtube.com/watch?v=Uj47dxYPow8
    * References:
      * http://www.geeksforgeeks.org/fibonacci-heap-set-1-introduction/

* Priority Queue

  * About - is a data structure like a queue except **elements have associated Priority**
  where `next` and `pop` methods return item with next highest Priority
    * Example - Refer to lib/containers/priority_queue.rb
  * **Priority Queues** used in graph problems
    * Example: **Dijkstra's Graph Algorithm (Shortest Path)**
    * Example: **A\* Search Algorithm (Shortest Path)**
      * Reference:
        * Search for A* at: https://ltfschoen.github.io/Artificial-Intelligence-Term1/
  * PriorityQueue (highest first) - size, push (with priority), clear, empty?, has_priority?,
    next (next highest priority item returned), pop (same as next but also remove it), delete
  * PriorityQueue (lowest first) - Same as highest first

* Deque (uses Stack and Queue)

  * About - is a container **allows items added/removed from both front and back**
  (**combination of Stack and a Queue**)
    * Example - Refer to lib/containers/deque.rb
    * Time Complexity: O(1) - for all operations when implemented using Doubly-Linked List
      * Reference: Ruby Doubly-Linked List example https://rubyrocksu.wordpress.com/doubly-linked-list/

* Stack (used by Deque)

  * About - is a container that keeps elements in a last-in first-out (**LIFO**) order.
    * Example - Refer to lib/containers/stack.rb
    * Examples
      * **Prefix-infix-postfix conversion**
      * **Backtracking problems**
    * Time Complexity: O(1) - complexity for all operations when implemented using Doubly-Linked List
      * Class's method complexities
        * Time Complexity: O(1) - next (get from back of queue), push (onto top of stack),
        pop (remove/get from back of queue), size, empty?, each (iterate stack in LIFO order)

* Queue

  * About - is a container that keeps elements in a first-in first-out (**FIFO**) order.
    * Example - Refer to lib/containers/queue.rb
    * Examples
      * **Buffer**
  * Note: Same as Stack but FIFO instead of LIFO

* Red-Black Trees

  * Reference: https://en.wikipedia.org/wiki/Red%E2%80%93black_tree
  * About RBTreeMap - **Self-balancing Binary Search Tree (BST)**, each tree node has black or red bit to keep tree balanced
  RBTreeMap is map stored in Sorted Order by Key (based on order of its keys by comparison using function <=>).
    * **RBTreeMap vs Hash / Hash Table**
      * Benefit is that **keys stored in order (so iterable in order)**
    so may efficiently traverse**
    * **RBTreeMap benefit** - self-balancing for good performance, otherwise could degenerate into list
    * Examples
      * **Sets - where only using keys and not storing values**

  * Example - Refer to lib/containers/rb_tree_map.rb
  * O(log n) (where n is total elements in tree) - Insert‎, Search‎ (lookup), Delete‎,
  Tree Re-Arrangement and Re-Colouring (after each tree modification)
    * Class's method complexities
      * Time Complexity: O(log n) - Insert (key), has_key?, get_key, min_key, max_key, delete (key), delete_min (of key, and return it)
      delete_max (of key, and return it), each (iterate treemap from smallest to largest element)
      * Time Complexity: O(1) - size, height (of tree), empty? (of tree)

* Splay Trees

    * About SplayTreeMap - a balanced Binary Tree, it is a map stored in **Ascending Order by Key**
      (based on keys comparison using function <=>)
    * Examples
      * **Network Router with IP Addresses**
        * Leverages key locality benefit of Splay Tree performance for fast IP address lookup since
        if IP Address once used is likely used again
        * Reference: http://www.cs.cornell.edu/courses/cs312/2008sp/lectures/lec25.html
    * **SplayTreeMap vs Hash / Hash Table
      * Benefit is that keys stored in order (so iterable in order)
        so may efficiently traverse**
      * Benefit is Splay Trees are **Self-Optimizing as recently accessed nodes stay near root**
      root so easily re-accessed later.
      * Benefit is Splay Trees are more simply implemented than Red-Black Trees
    * Class's method complexities
      * Time Complexity: **O(log n) "amortized" performance (Insert, Search, Delete)** - Insert (KV) push, has_key?, get (value for key), min (return smallest KV pair),
      max (return largest KV pair), delete (delete and return key), each (iterate Ascending order),
      splay (move key to root, updating each step), height_recursive (height of node)
      * Time Complexity: O(1) - size, clear, height
      * Time Complexity: O(n) worst case - when keys added in sorted order, causing tree to have height of number of items added

* Tries (based on Ternary Search Tree, for store and Pattern Matching)

  * About - is an Ordered data structure that stores KV pairs in tree
  * Reference:
    * **With Algorithm Code** - https://www.igvita.com/2009/03/26/ruby-algorithms-sorting-trie-heaps/
  * Class's method complexities
    * **O(m) Search/lookup (where m is the length of the key searched, and has no chance of collisions,
    unlike Hash Tables, so search misses are quickly detected**
  * Examples
    * **Longest Prefix Algorithms `longest_prefix`** - where routers in IP networking select entry from a forwarding table
    * **Wildcard Matching `wildcard`** - returns a sorted array containing strings that match the parameter string using wildcards
    * **Radix Sort**
    * **Route Pattern Matcher in Rails**
  * Class's method complexities
    * Time Complexity: O(m) - push / Insert (KV pair in tree), has_key?, get(key) (returns value of key),
    longest_prefix (longest key that has prefix in common with parameter string),
    wildcard (returns sorted array containing strings matching parameter string,
    wildcard characters that match any character are '*' and '.')

* Suffix Array

  * About - fast substring search of a given string. It creates and stores in Ascending Order
  an array of all possible substrings, then performs binary search to find a desired substring among those stored.
  * Examples
    * **Substring in String Search**
  * Class's method complexities
    * Time Complexity: O(m log n) - `has_substring?` Search and find substrings time, where:
      * m is length of substring to search for
      * n is the total number of substrings

* Search algorithms

  * Binary Search (i.e. BST, see RBTreeMap)
    * About - search to finds given item in list
    * Example - Refer to lib/algorithms/search.rb
    * Class's method complexities
      * Time Complexity: O(log n) - `binary_search` Find item time if container already sorted

  * Knuth-Morris-Pratt (KMP) Search
    * About - finds the starting position of a substring in a string efficiently,
    and calculates the best position to resume searching from if a failure occurs
    * Example - Refer to lib/algorithms/search.rb
    * Examples
      * **Substring Search - Pattern Matching**
        * Time Complexity: O(n+k) time - `kmp_search`
          * n - length of string being searched
          * k - length of substring pattern being searching for
        * Reference: https://www.youtube.com/watch?v=GTJr8OvyEVQ

* Sorting algorithms

  * Computational complexity
    * Reference https://en.wikipedia.org/wiki/Sorting_algorithm
    * About - (worst, average and best behavior) in terms of the size of the list (n).
      * Serial sort
        * Best behaviour is O(n)
        * Good behaviour is O(n log n)
      * Parallel sort
        * Best behaviour is O(log n)
        * Good behaviour is O(log2 n)
        * Bad behavior is O(n^2)

  * Exchange sort types

    * Bubble sort
      * About - keeps swapping elements in list until container sorted by comparing elements with <=>
      **Note: Nested loops used in most sorts so n^2 time**
        * Time Complexity: О(n^2)
        * Space Complexity: О(n) total, O(1) auxiliary
      * Example - Refer to lib/algorithms/sort.rb

    * Comb sort
      * About - variation of **Bubble Sort with dramatically improved performance**
      sorted by comparing elements with <=>
      * Reference: http://yagni.com/combsort/
        * Time Complexity: О(n^2)
        * Space Complexity: О(n) total, O(1) auxiliary

    * Quicksort
      * About - **Unstable Divide-and-conquer sort that recursively Partitions container until it is Sorted**
      Container should implement `pop` and include the **Enumerable module**
        * Time Complexity: О(n log n) average, O(n^2) worst-case
        * Space Complexity: О(n) auxiliary
        * Stable: No

    * Mergesort
      * About - Stable divide-and-conquer that sorts small chunks of container, then merges them together.
        * Time Complexity: О(n log n) average and worst-case
        * Space Complexity: О(n) auxiliary
        * Stable: Yes

    * Dual-Pivot Quicksort
      * About - Variation of Quicksort implementation algorithm from original research paper:
      http://iaroslavski.narod.ru/quicksort/DualPivotQuicksort.pdf.
      Implemented as the default sort algorithm for primatives in Java 7.
      Implementation in the Java JDK as of November, 2011: http://www.docjar.com/html/api/java/util/DualPivotQuicksort.java.html
      Proved that **Dual-Pivot Quicksort has on average 20% less swaps than classical Quicksort algorithm**.
      Container should implement `pop` and include the **Enumerable module**
        * Time Complexity: O(n log(n)) average/worst case performance on many data sets that cause
        other quicksorts to degrade to quadratic performance. Typically
        faster than traditional (one-pivot) Quicksort implementations."
        * Space Complexity: О(n) auxiliary
        * Stable: No

  * Selection sort types

    * Selection sort
      * About - **iterates container, selects the Smallest element, Moves it to beginning. Repeat until end reached.**
      Compares elements with <=>
        * Time Complexity: О(n^2)
        * Space Complexity: О(n) total, O(1) auxiliary

    * Heapsort
      * About - Uses **a Heap to Sort collection**. Compares elements with <=>
        * Time Complexity: О(n^2)
        * Space Complexity: О(n) total, O(1) auxiliary

  * Insertion sort
    * About - **Elements inserted sequentially into right position**. Compares elements with <=>
      * Time Complexity: О(n^2)
      * Space Complexity: О(n) total, O(1) auxiliary

  * Shell sort
    * About - Similar to **Insertion Sort but slightly better**. Compare elements with <=>
      * Time Complexity: О(n^2)
      * Space Complexity: О(n) total, O(1) auxiliary

* Other Repositories
  * Bloom Filters https://www.igvita.com/2008/12/27/scalable-datasets-bloom-filters-in-ruby/