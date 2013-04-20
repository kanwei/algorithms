# algorithms [![Build Status](https://travis-ci.org/kanwei/algorithms.png)](https://travis-ci.org/kanwei/algorithms)

## DESCRIPTION:

Started as a [Google Summer of Code 2008](http://code.google.com/soc/2008/ruby/about.html) project

Written by [Kanwei Li](http://kanwei.com/), mentored by Austin Ziegler

### Original Proposal: ###

Using the right data structure or algorithm for the situation is an important
aspect of programming. In computer science literature, many data structures
and algorithms have been researched and extensively documented. However, there
is still no standard library in Ruby implementing useful structures and
algorithms like Red/Black Trees, tries, different sorting algorithms, etc.
This project will create such a library with documentation on when to use a
particular structure/algorithm. It will also come with a benchmark suite to
compare performance in different situations.

## COMPLETED:

    * Heaps              Containers::Heap, Containers::MaxHeap, Containers::MinHeap
    * Priority Queue     Containers::PriorityQueue
    * Deque              Containers::Deque, Containers::CDeque (C ext)
    * Stack              Containers::Stack
    * Queue              Containers::Queue
    * Red-Black Trees    Containers::RBTreeMap, Containers::CRBTreeMap (C ext)
    * Splay Trees        Containers::SplayTreeMap, Containers::CSplayTreeMap (C ext)
    * Tries              Containers::Trie
    * Suffix Array       Containers::SuffixArray

    * Search algorithms
      - Binary Search            Algorithms::Search.binary_search
      - Knuth-Morris-Pratt       Algorithms::Search.kmp_search
    * Sorting algorithms           
      - Bubble sort              Algorithms::Sort.bubble_sort
      - Comb sort                Algorithms::Sort.comb_sort
      - Selection sort           Algorithms::Sort.selection_sort
      - Heapsort                 Algorithms::Sort.heapsort
      - Insertion sort           Algorithms::Sort.insertion_sort
      - Shell sort               Algorithms::Sort.shell_sort
      - Quicksort                Algorithms::Sort.quicksort
      - Mergesort                Algorithms::Sort.mergesort
      - Dual-Pivot Quicksort     Algorithms::Sort.dualpivotquicksort

## SYNOPSIS:

    require 'rubygems'
    require 'algorithms'

    max_heap = Containers::MaxHeap.new

    # To not have to type "Containers::" before each class, use:
    include Containers
    max_heap = MaxHeap.new

## REQUIREMENTS:

* Ruby 1.8, Ruby 1.9, JRuby
* C extensions (optional, but very much recommended for vast performance benefits)

## LICENSE:

(The MIT License)

Ruby Algorithms and Containers project is Copyright (c) 2009 Kanwei Li

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
