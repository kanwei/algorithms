%w(heap stack queue priority_queue tree_map).each { |file| require "#{File.dirname(__FILE__)}/containers/#{file}" }
begin
  require 'CTreeMap'
  Containers::TreeMap = Containers::CTreeMap
rescue LoadError # C Version could not be found, try ruby version
  Containers::TreeMap = Containers::RubyTreeMap
end
