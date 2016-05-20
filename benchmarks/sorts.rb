$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Algorithms

require 'rubygems'
begin
  require 'rbench'
rescue LoadError
  abort "\n\tYou need to run `gem install rbench` and then try to rerun one more time.\n\n"
end

RBench.run(5) do

  sorts = %w(ruby comb_sort heapsort insertion_sort shell_sort quicksort mergesort)
  sorts.each { |sort| self.send(:column, sort.intern) }

  n = 4000

  proc = lambda { |scope, ary|
    scope.ruby { ary.dup.sort }
    scope.comb_sort { Sort.comb_sort(ary.dup) }
    scope.heapsort { Sort.heapsort(ary.dup) }
    scope.insertion_sort { Sort.insertion_sort(ary.dup) }
    scope.shell_sort { Sort.shell_sort(ary.dup) }
    scope.quicksort { Sort.quicksort(ary.dup) }
    scope.mergesort { Sort.mergesort(ary.dup) }
  }

  report "Already sorted" do
    sorted_array = Array.new(n) { rand(n) }.sort
    proc.call(self, sorted_array)
  end

  report "Random" do
    random_array = Array.new(n) { rand(n) }
    proc.call(self, random_array)
  end
end