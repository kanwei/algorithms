%w(heap stack queue priority_queue tree_map).each { |file| require "#{File.dirname(__FILE__)}/containers/#{file}" }
require "#{File.dirname(__FILE__)}/../ext/containers/tree_map/c_tree_map"

class Algorithms
  VERSION = '0.0.1'
end