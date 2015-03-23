$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

unless defined? RUBY_ENGINE && RUBY_ENGINE == 'jruby'
  describe 'map gc mark test' do
    it 'should mark ruby object references' do
      anon_key_class = Class.new do
        attr_reader :value
        def initialize(x)
          @value = x
        end

        def <=>(other)
          value <=> other.value
        end
      end
      anon_val_class = Class.new
      @rbtree = Containers::RBTreeMap.new
      @splaytree = Containers::SplayTreeMap.new
      100.times do |x|
        @rbtree[anon_key_class.new(x)] = anon_val_class.new
        @splaytree[anon_key_class.new(x)] = anon_val_class.new
      end
      # Mark and sweep
      ObjectSpace.garbage_collect
      # Check if any instances were swept
      count = 0
      ObjectSpace.each_object(anon_key_class) { |_x| count += 1 }
      expect(count).to eql(200)
      ObjectSpace.each_object(anon_val_class) { |_x| count += 1 }
      expect(count).to eql(400)
    end
  end
end
