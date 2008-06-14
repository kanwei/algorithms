require 'lib/algorithms'

describe DS::RedBlackTree do
  before(:each) do
    @tree = DS::RedBlackTree.new
  end
  
  describe "(empty)" do
    it "should let you put stuff in" do
      100.times { |x| @tree.put(x, x) }
      @tree.size.should eql(100)
    end
    
    it "should return 0 for height" do
      @tree.height.should eql(0)
    end
    
    it "should return 0 for size" do
      @tree.size.should eql(0)
    end
    
    it "should return nil for min and max" do
      @tree.min.should eql(nil)
      @tree.max.should eql(nil)
    end
    
  end
  
  describe "(non-empty)" do
    before(:each) do
      @num_items = 100
      @random_array = []
      @num_items.times { @random_array << rand(@num_items) }
      @random_array.each { |x| @tree.put(x, x) }
    end
    
    it "should return correct size (uniqify items first)" do
      @tree.size.should eql(@random_array.uniq.size)
    end
    
    it "should return correct max and min" do
      @tree.min.should eql(@random_array.min)
      @tree.max.should eql(@random_array.max)
    end
    
    it "should not #contain? keys it doesn't have" do
      @tree.contains?(10000).should eql(false)
    end
    
    it "should #contain? keys it does have" do
      @tree.contains?(@random_array[0]).should eql(true)
    end
    
  end
  
end