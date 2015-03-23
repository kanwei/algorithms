# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'algorithms'
  s.version = '0.6.1'

  s.authors = ['Kanwei Li']
  s.email = 'kanwei@gmail.com'
  s.license = 'MIT'
  s.date = '2013-01-22'
  s.summary = 'Useful algorithms and data structures for Ruby. Optional C extensions.'
  s.description = 'Heap, Priority Queue, Deque, Stack, Queue, Red-Black Trees, Splay Trees, sorting algorithms, and more'
  s.files = `git ls-files`.split($RS)
  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
    s.platform = 'java'
  else
    s.extensions = s.files.grep(%r{^ext/})
  end
  s.homepage = 'https://github.com/kanwei/algorithms'
  s.rdoc_options = ['--line-numbers', '--inline-source', '--title', 'Algorithms', '--main', 'README.markdown']
  s.require_paths = %w(lib ext)
  s.rubyforge_project = 'algorithms'
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake-compiler')
  s.add_development_dependency('rubocop', '~> 0.44.1')
end
