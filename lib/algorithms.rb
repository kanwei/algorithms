%w(heap stack queue priority_queue tree).each { |file| require "#{File.dirname(__FILE__)}/datastructures/#{file}" }
require "#{File.dirname(__FILE__)}/../ext/datastructures/tree/credblacktree"

class Algorithms
  VERSION = '0.0.1'
end