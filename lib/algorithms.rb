=begin rdoc
  The 'Algorithms and Containers' library is an effort to provide a set of commonly used
  algorithms and containers to Ruby programmers.
  
  So far, the following containers have been implemented:
  * RubyTreeMap
  * Priority Queue
=end

# %w(heap stack queue priority_queue tree_map).each { |file| require "#{File.dirname(__FILE__)}/containers/#{file}" }
require 'containers/heap'
require 'containers/stack'
require 'containers/queue'
require 'containers/priority_queue'
require 'containers/tree_map'

begin
  require 'CTreeMap'
  Containers::TreeMap = Containers::CTreeMap
rescue LoadError # C Version could not be found, try ruby version
  Containers::TreeMap = Containers::RubyTreeMap
end

begin
  require 'CPriorityQueue'
  Containers::PriorityQueue = Containers::CPriorityQueue
rescue LoadError # C Version could not be found, try ruby version
  Containers::PriorityQueue = Containers::RubyPriorityQueue
end
