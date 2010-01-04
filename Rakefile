require 'rubygems'
require 'echoe'
 
Echoe.new('algorithms') do |p|
  p.author               = 'Kanwei Li'
  p.email                = 'kanwei@gmail.com'
  p.summary              = 'A library of algorithms and containers.'
  p.url                  = 'http://rubyforge.org/projects/algorithms/'
  p.version              = "0.2.0"
  p.runtime_dependencies = []
end

task :push do
  sh "git push"    # Rubyforge
  sh "git push --tags"    # Rubyforge
  sh "git push gh" # Github
  sh "git push gh --tags" # Github
end

task :hanna do
  sh "rm -fr doc"
  sh "hanna -SN lib/ -m Algorithms"
  sh "scp -rq doc/* kanwei@rubyforge.org:/var/www/gforge-projects/algorithms"
end

