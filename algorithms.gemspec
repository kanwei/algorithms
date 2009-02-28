# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{algorithms}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kanwei Li"]
  s.date = %q{2009-02-28}
  s.description = %q{A library of algorithms and containers.}
  s.email = %q{kanwei@gmail.com}
  s.extensions = ["ext/containers/bst/extconf.rb", "ext/containers/deque/extconf.rb", "ext/containers/tree_map/extconf.rb"]
  s.extra_rdoc_files = ["ext/containers/bst/bst.c", "ext/containers/bst/extconf.rb", "ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/tree_map/extconf.rb", "ext/containers/tree_map/rbtree.c", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb", "lib/graphs/graph.rb", "README"]
  s.files = ["algorithms.gemspec", "benchmark.rb", "benchmarks/rbench/column.rb", "benchmarks/rbench/group.rb", "benchmarks/rbench/report.rb", "benchmarks/rbench/runner.rb", "benchmarks/rbench/summary.rb", "benchmarks/rbench.rb", "benchmarks/sorts.rb", "ext/containers/bst/bst.c", "ext/containers/bst/extconf.rb", "ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/tree_map/extconf.rb", "ext/containers/tree_map/rbtree.c", "History.txt", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb", "lib/graphs/graph.rb", "Manifest", "Rakefile", "README", "spec/bst_spec.rb", "spec/deque_spec.rb", "spec/heap_spec.rb", "spec/kd_tree_spec.rb", "spec/priority_queue_spec.rb", "spec/queue_spec.rb", "spec/rb_tree_map_spec.rb", "spec/search_spec.rb", "spec/sort_spec.rb", "spec/splay_tree_map_spec.rb", "spec/stack_spec.rb", "spec/suffix_array_spec.rb", "spec/trie_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://rubyforge.org/projects/algorithms/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Algorithms", "--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{algorithms}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A library of algorithms and containers.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
