$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe Containers::BinaryHeap do
  before(:each) do
    @heap = Containers::MaxBinaryHeap.new
  end
  
  it "should not let you merge with non-heaps" do
    lambda { @heap.merge!(nil) }.should raise_error
    lambda { @heap.merge!([]) }.should raise_error
  end
  
  describe "(empty)" do
  
    it "should return nil when getting the maximum" do
      @heap.max!.should be_nil
    end
    
    it "should let you insert and remove one item" do
      @heap.size.should eql(0)
      
      @heap.push(1)
      @heap.size.should eql(1)
      
      @heap.max!.should eql(1)
      @heap.size.should eql(0)
    end
    
    it "should let you initialize with an array" do
      @heap = Containers::MaxBinaryHeap.new([1,2,3])
      @heap.size.should eql(3)
    end

  end
  
  describe "(non-empty)" do
    before(:each) do
      @random_array = []
      @num_items = 100
      @num_items.times { |x| @random_array << rand(@num_items) }
      @heap = Containers::MaxBinaryHeap.new(@random_array)
    end
    
    it "should display the correct size" do
      @heap.size.should eql(@num_items)
    end
    
    it "should have a next value" do
      @heap.next.should be_true
      @heap.next_key.should be_true
    end
    
    it "should be in max->min order" do
      ordered = []
      ordered << @heap.max! until @heap.empty?
      ordered.should eql(@random_array.sort.reverse)
    end
    
    it "should let you merge with another heap" do
      numbers = [1,2,3,4,5,6,7,8]
      otherheap = Containers::MaxBinaryHeap.new(numbers)
      otherheap.size.should eql(8)
      @heap.merge!(otherheap)
      
      ordered = []
      ordered << @heap.max! until @heap.empty?
      
      ordered.should eql( (@random_array + numbers).sort.reverse)
    end
    
    describe "min-heap" do
      it "should be in min->max order" do
        @heap = Containers::MinBinaryHeap.new(@random_array)
        ordered = []
        ordered << @heap.min! until @heap.empty?
    
        ordered.should eql(@random_array.sort)
      end
    end
    
  end
  
end
