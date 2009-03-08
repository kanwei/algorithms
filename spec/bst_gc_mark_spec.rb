$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

if defined? Containers::CBst
  describe "CBst" do
    it "should mark ruby object references" do
      anonymous_class = Class.new
      @bst = Containers::CBst.new
      100.times { |x| @bst.insert(x, anonymous_class.new) }
      # Mark and sweep
      ObjectSpace.garbage_collect
      # Check if any instances were swept
      ObjectSpace.each_object(anonymous_class).count.should eql(100)
    end
  end
end