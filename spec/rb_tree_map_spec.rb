$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

shared_examples "empty rbtree" do
  it "should let you push stuff in" do
    100.times { |x| @tree[x] = x }
    expect(@tree.size).to eql(100)
  end

  it "should be empty?" do
    expect(@tree.empty?).to be true
  end

  it "should return 0 for height" do
    expect(@tree.height).to eql(0)
  end

  it "should return 0 for size" do
    expect(@tree.size).to eql(0)
  end

  it "should return nil for max and min" do
    expect(@tree.min).to be_nil
    expect(@tree.max).to be_nil
    expect(@tree.min_key).to be_nil
    expect(@tree.max_key).to be_nil
  end

  it "should not delete" do
    expect(@tree.delete(:non_existing)).to be_nil
  end
end

shared_examples "non-empty rbtree" do
  before(:each) do
    @num_items = 1000
    @random_array = Array.new(@num_items) { rand(@num_items) }
    @random_array.each { |x| @tree[x] = x }
  end

  it "should return correct size (uniqify items first)" do
    expect(@tree).not_to be_empty
    expect(@tree.size).to eql(@random_array.uniq.size)
  end

  it "should return correct max and min" do
    expect(@tree.min_key).to eql(@random_array.min)
    expect(@tree.max_key).to eql(@random_array.max)
    expect(@tree.min[0]).to eql(@random_array.min)
    expect(@tree.max[0]).to eql(@random_array.max)
  end

  it "should not #has_key? keys it doesn't have" do
    expect(@tree.has_key?(100000)).to be false
  end

  it "should #has_key? keys it does have" do
    expect(@tree.has_key?(@random_array[0])).to be true
  end

  it "should remove all keys" do
    ordered = []
    @random_array.uniq.each do |key|
      expect(@tree.has_key?(key)).to eql(true)
      ordered << @tree.delete(key)
      expect(@tree.has_key?(key)).to eql(false)
    end
    expect(ordered).to eql(@random_array.uniq)
  end

  it "should delete_min keys correctly" do
    ascending = []
    ascending << @tree.delete_min until @tree.empty?
    expect(ascending).to eql(@random_array.uniq.sort)
  end

  it "should delete_max keys correctly" do
    descending = []
    descending << @tree.delete_max until @tree.empty?
    expect(descending).to eql(@random_array.uniq.sort.reverse)
  end

  it "should let you iterate with #each" do
    counter = 0
    sorted_array = @random_array.uniq.sort
    @tree.each do |key, val|
      expect(key).to eql(sorted_array[counter])
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