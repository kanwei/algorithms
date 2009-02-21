$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty rbtree", :shared => true do
  it "should let you push stuff in" do
    100.times { |x| @tree[x] = x }
    @tree.size.should eql(100)
  end

  it "should be empty?" do
    @tree.empty?.should be_true
  end

  it "should return 0 for height" do
    @tree.height.should eql(0)
  end

  it "should return 0 for size" do
    @tree.size.should eql(0)
  end

  it "should return nil for max and min" do
    @tree.min.should be_nil
    @tree.max.should be_nil
    @tree.min_key.should be_nil
    @tree.max_key.should be_nil
  end

  it "should not delete" do
    @tree.delete(:non_existing).should be_nil
  end
end

describe "non-empty rbtree", :shared => true do
  before(:each) do
    @num_items = 1000
    @random_array = Array.new(@num_items) { rand(@num_items) }
    @random_array.each { |x| @tree[x] = x }
  end

  it "should return correct size (uniqify items first)" do
    @tree.should_not be_empty
    @tree.size.should eql(@random_array.uniq.size)
  end

  it "should return correct max and min" do
    @tree.min_key.should eql(@random_array.min)
    @tree.max_key.should eql(@random_array.max)
    @tree.min[0].should eql(@random_array.min)
    @tree.max[0].should eql(@random_array.max)
  end

  it "should not #has_key? keys it doesn't have" do
    @tree.has_key?(100000).should be_false
  end

  it "should #has_key? keys it does have" do
    @tree.has_key?(@random_array[0]).should be_true
  end

  it "should remove all keys" do
    ordered = []
    @random_array.uniq.each do |key|
      @tree.has_key?(key).should eql(true)
      ordered << @tree.delete(key)
      @tree.has_key?(key).should eql(false)
    end
    ordered.should eql(@random_array.uniq)
  end

  it "should delete_min keys correctly" do
    ascending = []
    ascending << @tree.delete_min until @tree.empty?
    ascending.should eql(@random_array.uniq.sort)
  end

  it "should delete_max keys correctly" do
    descending = []
    descending << @tree.delete_max until @tree.empty?
    descending.should eql(@random_array.uniq.sort.reverse)
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

describe "empty rbtreemap" do
  before(:each) do
    @tree = Containers::RubyRBTreeMap.new
  end
  it_should_behave_like "empty rbtree"
end

describe "full rbtreemap" do
  before(:each) do
    @tree = Containers::RubyRBTreeMap.new
  end
  it_should_behave_like "non-empty rbtree"
end

begin
  Containers::CRBTreeMap
  describe "empty crbtreemap" do
    before(:each) do
      @tree = Containers::CRBTreeMap.new
    end
    it_should_behave_like "empty rbtree"
  end

  describe "full crbtreemap" do
    before(:each) do
      @tree = Containers::CRBTreeMap.new
    end
    it_should_behave_like "non-empty rbtree"
  end
rescue Exception
end