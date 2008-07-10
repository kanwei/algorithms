require 'lib/containers/rb_tree_map'
require 'lib/CRBTreeMap'
  
describe "(empty)", :shared => true do
  it "should let you push stuff in" do
    100.times { |x| @tree[x] = x }
    @tree.size.should eql(100)
  end
  
  it "should return 0 for height" do
    @tree.height.should eql(0)
  end
  
  it "should return 0 for size" do
    @tree.size.should eql(0)
  end
  
  it "should return nil for #min_key and #max_key" do
    @tree.min_key.should eql(nil)
    @tree.max_key.should eql(nil)
  end
  
  it "should not delete" do
    @tree.delete(:non_existing).should eql(nil)
  end
end

describe "(non-empty)", :shared => true do
  before(:each) do
    @num_items = 100
    @random_array = []
    @num_items.times { @random_array << rand(@num_items) }
    @random_array.each { |x| @tree[x] = x }
  end
  
  it "should return correct size (uniqify items first)" do
    @tree.size.should eql(@random_array.uniq.size)
  end
  
  it "should return correct max and min keys" do
    @tree.min_key.should eql(@random_array.min)
    @tree.max_key.should eql(@random_array.max)
  end
  
  it "should not #has_key? keys it doesn't have" do
    @tree.has_key?(100000).should eql(false)
  end
  
  it "should #has_key? keys it does have" do
    @tree.has_key?(@random_array[0]).should eql(true)
  end
  
  it "should remove all keys -- KNOWN BUGS" do
    # @random_array = [43, 48, 55, 27,28, 39,31, 30, 34, 36, 35, 18, 37, 62, 38, 33, 47, 21, 10, 11, 17] <- fails
    @tree = Containers::RubyRBTreeMap.new
    @random_array.each { |x| @tree[x] = x }
    ordered = []
    @random_array.uniq.each do |key|
      # puts "#{key} #{@tree.size}"
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

describe Containers::CRBTreeMap do
  describe "empty" do
    before(:each) do
      @tree = Containers::CRBTreeMap.new
    end
    it_should_behave_like "(empty)"
  end
  
  describe "full" do
    before(:each) do
      @tree = Containers::CRBTreeMap.new
    end
    it_should_behave_like "(non-empty)"
  end
end

describe Containers::RubyRBTreeMap do
  describe "empty" do
    before(:each) do
      @tree = Containers::RubyRBTreeMap.new
    end
    it_should_behave_like "(empty)"
  end
  
  describe "full" do
    before(:each) do
      @tree = Containers::RubyRBTreeMap.new
    end
    it_should_behave_like "(non-empty)"
  end
end
