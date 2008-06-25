= algorithms

* http://rubyforge.org/projects/algorithms/

== DESCRIPTION:

Using the right data structure or algorithm for the situation is an important aspect of programming. In computer science literature, many data structures and algorithms have been researched and extensively documented. However, there is still no standard library in Ruby implementing useful structures and algorithms like Red/Black Trees, tries, graphs, different sorting algorithms, etc. This project will create such a library with documentation on when to use a particular structure/algorithm. It will also come with a benchmark suite to compare performance in different situations.

== FEATURES/PROBLEMS:

Done so far:
* Heaps (Maximum, Minimum)
* Priority Queue
* Stack
* Queue
* TreeMap

== SYNOPSIS:

  require 'rubygems'
  require 'algorithms'
  
  include Containers
  max_heap = MaxHeap.new

== REQUIREMENTS:

* Ruby 1.8
* C compiler for extensions (optional)

== INSTALL:

* sudo gem install

== LICENSE:

(The MIT License)

Copyright (c) 2008 Kanwei Li

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
