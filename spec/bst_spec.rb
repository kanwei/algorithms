# $: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
# require "algorithms"
#
# begin
#   Containers::CBst
#   describe "binary search tree" do
#     it "should let user push new elements with key" do
#       @bst = Containers::CBst.new
#       100.times { |x| @bst.push(x, "hello : #{x}") }
#       @bst.size.should eql(100)
#     end
#
#     it "should allow users to delete elements" do
#       @bst = Containers::CBst.new
#       @bst.push(10, "hello world")
#       @bst.push(11, "hello world")
#       @bst.delete(11)
#       @bst.size.should eql(1)
#       @bst.delete(10)
#       @bst.size.should eql(0)
#     end
#
#   end
# rescue Exception
# end
