require 'rubygems'
require 'echoe'

Echoe.new('algorithms') do |p|
  p.author  = 'Kanwei Li'
  p.email   = 'kanwei@gmail.com'
  p.summary = 'A library of algorithms and containers.'
  p.url     = 'http://rubyforge.org/projects/algorithms/'
  p.version = "0.0.1"
  p.runtime_dependencies = []
end

task :default => :spec

task :spec => :compile do
  sh "spec -c spec/"
end