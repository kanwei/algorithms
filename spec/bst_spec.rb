$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require "algorithms"

describe "binary search tree" do
  it "should let user insert new elements with key" do
    @bst = Containers::CBst.new
    100.times { |x| @bst.insert(x, "hello : #{x}") }
    @bst.size.should eql(100)
  end

  it "should allow users to delete elements" do
    @bst = Containers::CBst.new
    @bst.insert(10, "hello world")
    @bst.insert(11, "hello world")
    @bst.delete(11)
    @bst.size.should eql(1)
    @bst.delete(10)
    @bst.size.should eql(0)
  end

  it "should throw exception on invalid key delete" do
    @bst = Containers::CBst.new
    @bst.insert(10,"Hello world")
    lambda { @bst.delete(20) }.should raise_error(ArgumentError)
    @bst.size.should eql(1)
  end
end
