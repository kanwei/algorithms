# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/algorithms.rb'

Hoe.new('algorithms', Algorithms::VERSION) do |p|
  # p.rubyforge_name = 'algorithmsx' # if different than lowercase project name
  p.developer('Kanwei Li', 'kanwei@gmail.com')
end

# vim: syntax=Ruby

task :default => :spec

task :spec do
  sh "cd ext/datastructures/tree; make"
  sh "spec spec/*spec.rb"
end