$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'
  
shared_examples "empty splaytree" do
  it "should let you push stuff in" do
    100.times { |x| @tree[x] = x }
    expect(@tree.size).to eql(100)
  end
  
  it "should return 0 for size" do
    expect(@tree.size).to eql(0)
  end
  
  it "should return nil for #min and #max" do
    expect(@tree.min).to be_nil
    expect(@tree.max).to be_nil
  end
  
  it "should return nil for #delete" do
    expect(@tree.delete(:non_existing)).to be_nil
  end
  
  it "should return nil for #get" do
    expect(@tree[4235]).to be_nil
  end
end

shared_examples "non-empty splaytree" do
  before(:each) do
    @num_items = 100
    @random_array = []
    @num_items.times { @random_array << rand(@num_items) }
    @random_array.each { |x| @tree[x] = x }
  end
  
  it "should return correct size (uniqify items first)" do
    expect(@tree.size).to eql(@random_array.uniq.size)
  end
  
  it "should have correct height (worst case is when items are inserted in order, and height = num items inserted)" do
    @tree.clear
    10.times { |x| @tree[x] = x }
    expect(@tree.height).to eql(10)
  end
  
  it "should return correct max and min keys" do
    expect(@tree.min[0]).to eql(@random_array.min)
    expect(@tree.max[0]).to eql(@random_array.max)
  end
  
  it "should not #has_key? keys it doesn't have" do
    expect(@tree.has_key?(10000)).to be false
  end
  
  it "should #has_key? keys it does have" do
    expect(@tree.has_key?(@random_array[0])).to be true
  end
  
  it "should remove any key" do
    random_key = @random_array[rand(@num_items)]
    expect(@tree.has_key?(random_key)).to be true
    expect(@tree.delete(random_key)).to eql(random_key)
    expect(@tree.has_key?(random_key)).to be false
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

describe "empty splaytreemap" do
  before(:each) do
    @tree = Containers::RubySplayTreeMap.new
  end
  it_should_behave_like "empty splaytree"
end

describe "full splaytreemap" do
  before(:each) do
    @tree = Containers::RubySplayTreeMap.new
  end
  it_should_behave_like "non-empty splaytree"
end

begin
  Containers::CSplayTreeMap
  describe "empty csplaytreemap" do
    before(:each) do
      @tree = Containers::CSplayTreeMap.new
    end
    it_should_behave_like "empty splaytree"
  end

  describe "full csplaytreemap" do
    before(:each) do
      @tree = Containers::CSplayTreeMap.new
    end
    it_should_behave_like "non-empty splaytree"
  end
rescue Exception
end
