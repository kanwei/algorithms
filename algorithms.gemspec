# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{algorithms}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kanwei Li"]
  s.date = %q{2009-03-29}
  s.description = %q{A library of algorithms and containers.}
  s.email = %q{kanwei@gmail.com}
  s.extensions = ["ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/splaytree_map/extconf.rb"]
  s.extra_rdoc_files = ["ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/rbtree_map/rbtree.c", "ext/containers/splaytree_map/extconf.rb", "ext/containers/splaytree_map/splaytree.c", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb", "README.markdown"]
  s.files = ["algorithms.gemspec", "benchmarks/deque.rb", "benchmarks/sorts.rb", "benchmarks/treemaps.rb", "ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/rbtree_map/rbtree.c", "ext/containers/splaytree_map/extconf.rb", "ext/containers/splaytree_map/splaytree.c", "History.txt", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb", "Manifest", "Rakefile", "README.markdown", "spec/deque_gc_mark_spec.rb", "spec/deque_spec.rb", "spec/heap_spec.rb", "spec/kd_tree_spec.rb", "spec/priority_queue_spec.rb", "spec/queue_spec.rb", "spec/rb_tree_map_gc_mark_spec.rb", "spec/rb_tree_map_spec.rb", "spec/search_spec.rb", "spec/sort_spec.rb", "spec/splay_tree_map_spec.rb", "spec/stack_spec.rb", "spec/suffix_array_spec.rb", "spec/trie_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://rubyforge.org/projects/algorithms/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Algorithms", "--main", "README.markdown"]
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
