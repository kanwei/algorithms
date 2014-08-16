$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

if defined? Containers::CDeque
  describe "CDeque" do
    it "should mark ruby object references" do
      anon_class = Class.new
      @deque = Containers::CDeque.new
      100.times { @deque.push_front(anon_class.new) }
      # Mark and sweep
      ObjectSpace.garbage_collect
      # Check if any instances were swept
      count = 0
      ObjectSpace.each_object(anon_class) { |x| count += 1 }
      expect(count).to eql(100)
    end
  end
end