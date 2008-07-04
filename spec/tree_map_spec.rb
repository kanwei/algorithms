require 'lib/containers/tree_map'
require 'lib/CTreeMap'
  
describe "(empty)", :shared => true do
  it "should let you put stuff in" do
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
  
  it "should not #contains_key? keys it doesn't have" do
    @tree.contains_key?(10000).should eql(false)
  end
  
  it "should #contains_key? keys it does have" do
    @tree.contains_key?(@random_array[0]).should eql(true)
  end
  
  it "should remove any key" do
    random_key = @random_array[rand(@num_items)]
    @tree.contains_key?(random_key).should eql(true)
    @tree.delete(random_key).should eql(random_key)
    @tree.contains_key?(random_key).should eql(false)
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

describe Containers::CTreeMap do
  describe "empty" do
    before(:each) do
      @tree = Containers::CTreeMap.new
    end
    it_should_behave_like "(empty)"
  end
  
  describe "full" do
    before(:each) do
      @tree = Containers::CTreeMap.new
    end
    it_should_behave_like "(non-empty)"
  end
end

describe Containers::RubyTreeMap do
  describe "empty" do
    before(:each) do
      @tree = Containers::RubyTreeMap.new
    end
    it_should_behave_like "(empty)"
  end
  
  describe "full" do
    before(:each) do
      @tree = Containers::RubyTreeMap.new
    end
    it_should_behave_like "(non-empty)"
  end
end
