require 'rubygems'
require 'rake/extensiontask'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

Rake::ExtensionTask.new('algorithms/string')        { |ext| ext.name = 'CString' }
Rake::ExtensionTask.new('containers/deque')         { |ext| ext.name = 'CDeque' }
Rake::ExtensionTask.new('containers/bst')           { |ext| ext.name = 'CBst' }
Rake::ExtensionTask.new('containers/rbtree_map')    { |ext| ext.name = 'CRBTreeMap' }
Rake::ExtensionTask.new('containers/splaytree_map') { |ext| ext.name = 'CSplayTreeMap' }

RSpec::Core::RakeTask.new
RuboCop::RakeTask.new

if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  task default: [:spec]
else
  task default: [:compile, :spec, :rubocop]
end

task :rdoc do
  `rdoc -f hanna --main algorithms.rb -t "Ruby Algorithms and Containers Documentation"`
end
