$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "map gc mark test" do
  it "should mark ruby object references" do
    anon_key_class = Class.new do
      attr :value
      def initialize(x); @value = x; end
      def <=>(other); value <=> other.value; end
    end
    anon_val_class = Class.new
    @rbtree = Containers::CRBTreeMap.new
    @splaytree = Containers::CSplayTreeMap.new
    100.times { |x| 
      @rbtree[anon_key_class.new(x)] = anon_val_class.new
      @splaytree[anon_key_class.new(x)] = anon_val_class.new
    }
    # Mark and sweep
    ObjectSpace.garbage_collect
    # Check if any instances were swept
    count = 0
    ObjectSpace.each_object(anon_key_class) { |x| count += 1 }
    count.should eql(200)
    ObjectSpace.each_object(anon_val_class) { |x| count += 1 }
    count.should eql(400)
  end
end