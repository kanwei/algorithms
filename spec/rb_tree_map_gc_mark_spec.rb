$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

if defined? Containers::CRBTreeMap
  describe "CRBTreeMap" do
    it "should mark ruby object references" do
      anonymous_class = Class.new
      @tree = Containers::CRBTreeMap.new
      100.times { |x| @tree[x] = anonymous_class.new }
      GC.enable
      # Mark and sweep
      ObjectSpace.garbage_collect
      # Check if any instances were swept
      ObjectSpace.each_object(anonymous_class).count.should eql(100)
    end
  end
end