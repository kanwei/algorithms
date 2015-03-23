$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require 'algorithms'
include Algorithms

require 'rubygems'
require 'rbench'

RBench.run(2) do
  %w(array deque).each { |s| send(:column, s.intern) }
  deque = Containers::Deque.new
  array = []

  report 'Insertion at end' do
    array { 1_000_000.times  { |x| array << x } }
    deque { 1_000_000.times  { |x| deque.push_back(x) } }
  end
end
