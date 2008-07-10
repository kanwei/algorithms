require 'lib/containers/splay_tree_map'
  
describe "(empty splay)", :shared => true do
  it "should let you put stuff in" do
    100.times { |x| @tree[x] = x }
    @tree.size.should eql(100)
  end
  
  it "should return 0 for size" do
    @tree.size.should eql(0)
  end
  
  it "should return nil for #min and #max" do
    @tree.min.should eql(nil)
    @tree.max.should eql(nil)
  end
  
  it "should return nil for #delete" do
    @tree.delete(:non_existing).should eql(nil)
  end
end

describe "(non-empty splay)", :shared => true do
  before(:each) do
    @num_items = 100
    @random_array = []
    @num_items.times { @random_array << rand(@num_items) }
    @random_array.each { |x| @tree[x] = x }
  end
  
  it "should return correct size (uniqify items first)" do
    @tree.size.should eql(@random_array.uniq.size)
  end
  
  it "should have correct height (worst case is when items are inserted in order, and height = num items inserted)" do
    @tree.clear
    10.times { |x| @tree[x] = x }
    @tree.height.should eql(10)
  end
  
  it "should return correct max and min keys" do
    @tree.min[0].should eql(@random_array.min)
    @tree.max[0].should eql(@random_array.max)
  end
  
  it "should not #has_key? keys it doesn't have" do
    @tree.has_key?(10000).should eql(false)
  end
  
  it "should #has_key? keys it does have" do
    @tree.has_key?(@random_array[0]).should eql(true)
  end
  
  it "should remove any key" do
    random_key = @random_array[rand(@num_items)]
    @tree.has_key?(random_key).should eql(true)
    @tree.delete(random_key).should eql(random_key)
    @tree.has_key?(random_key).should eql(false)
  end
  
  it "should let you iterate with #each" do
    counter = 0
    sorted_array = @random_array.uniq.sort
    @tree.each do |key, val|
      key.should eql(sorted_array[counter])
      counter += 1
    end
  end
end

# describe Containers::CRBTreeMap do
#   describe "empty" do
#     before(:each) do
#       @tree = Containers::CRBTreeMap.new
#     end
#     it_should_behave_like "(empty)"
#   end
#   
#   describe "full" do
#     before(:each) do
#       @tree = Containers::CRBTreeMap.new
#     end
#     it_should_behave_like "(non-empty)"
#   end
# end

describe Containers::SplayTreeMap do
  describe "empty" do
    before(:each) do
      @tree = Containers::SplayTreeMap.new
    end
    it_should_behave_like "(empty splay)"
  end
  
  describe "full" do
    before(:each) do
      @tree = Containers::SplayTreeMap.new
    end
    it_should_behave_like "(non-empty splay)"
  end
end
