$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require "algorithms"


describe "For Binary search tree" do
  it "should let user insert new elements with key" do
    @bst = Containers::CBst.new
    100.times { |x| @bst.insert(x,"hello : #{x}")}
  end
end
