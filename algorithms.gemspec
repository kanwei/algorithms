# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "algorithms"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kanwei Li"]
  s.date = "2012-04-25"
  s.description = "A library of algorithms and data structures (containers)."
  s.email = "kanwei@gmail.com"
  s.extensions = ["ext/algorithms/string/extconf.rb", "ext/containers/bst/extconf.rb", "ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/splaytree_map/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG.markdown", "README.markdown", "ext/algorithms/string/extconf.rb", "ext/algorithms/string/string.c", "ext/containers/bst/bst.c", "ext/containers/bst/extconf.rb", "ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/rbtree_map/rbtree.c", "ext/containers/splaytree_map/extconf.rb", "ext/containers/splaytree_map/splaytree.c", "lib/algorithms.rb", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms/string.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb"]
  s.files = ["CHANGELOG.markdown", "Manifest", "README.markdown", "Rakefile", "algorithms.gemspec", "benchmarks/deque.rb", "benchmarks/sorts.rb", "benchmarks/treemaps.rb", "ext/algorithms/string/extconf.rb", "ext/algorithms/string/string.c", "ext/containers/bst/bst.c", "ext/containers/bst/extconf.rb", "ext/containers/deque/deque.c", "ext/containers/deque/extconf.rb", "ext/containers/rbtree_map/extconf.rb", "ext/containers/rbtree_map/rbtree.c", "ext/containers/splaytree_map/extconf.rb", "ext/containers/splaytree_map/splaytree.c", "lib/algorithms.rb", "lib/algorithms/search.rb", "lib/algorithms/sort.rb", "lib/algorithms/string.rb", "lib/containers/deque.rb", "lib/containers/heap.rb", "lib/containers/kd_tree.rb", "lib/containers/priority_queue.rb", "lib/containers/queue.rb", "lib/containers/rb_tree_map.rb", "lib/containers/splay_tree_map.rb", "lib/containers/stack.rb", "lib/containers/suffix_array.rb", "lib/containers/trie.rb", "spec/bst_gc_mark_spec.rb", "spec/bst_spec.rb", "spec/deque_gc_mark_spec.rb", "spec/deque_spec.rb", "spec/heap_spec.rb", "spec/kd_expected_out.txt", "spec/kd_test_in.txt", "spec/kd_tree_spec.rb", "spec/map_gc_mark_spec.rb", "spec/priority_queue_spec.rb", "spec/queue_spec.rb", "spec/rb_tree_map_spec.rb", "spec/search_spec.rb", "spec/sort_spec.rb", "spec/splay_tree_map_spec.rb", "spec/stack_spec.rb", "spec/string_spec.rb", "spec/suffix_array_spec.rb", "spec/trie_spec.rb"]
  s.homepage = "https://rubygems.org/gems/algorithms"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Algorithms", "--main", "README.markdown"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = "algorithms"
  s.rubygems_version = "1.8.15"
  s.summary = "A library of algorithms and data structures (containers)."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
