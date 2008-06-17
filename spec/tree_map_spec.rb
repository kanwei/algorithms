require 'lib/algorithms'

describe Containers::TreeMap do
  before(:each) do
    @tree = Containers::TreeMap.new
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
    
    it "should return nil for #min_key and #max_key" do
      @tree.min_key.should eql(nil)
      @tree.max_key.should eql(nil)
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
    
    it "should return correct max and min keys" do
      @tree.min_key.should eql(@random_array.min)
      @tree.max_key.should eql(@random_array.max)
    end
    
    it "should not #contain? keys it doesn't have" do
      @tree.contains?(10000).should eql(false)
    end
    
    it "should #contain? keys it does have" do
      @tree.contains?(@random_array[0]).should eql(true)
    end
    
    it "should remove max key with #delete_max_key" do
      max = @tree.max_key
      @tree.contains?(max).should eql(true)
      @tree.delete_max_key
      @tree.contains?(max).should eql(false)
    end
    
    it "should remove min key with #delete_min_key" do
      min = @tree.min_key
      @tree.contains?(min).should eql(true)
      @tree.delete_min_key
      @tree.contains?(min).should eql(false)
    end
    
    it "should remove any key" do
      random_key = @random_array[rand(@num_items)]
      @tree.contains?(random_key).should eql(true)
      @tree.delete(random_key).should eql(nil)
      @tree.contains?(random_key).should eql(false)
    end
  end
  
end