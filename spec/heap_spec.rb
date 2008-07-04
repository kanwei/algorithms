require 'lib/containers/heap'

describe Containers::Heap do
  before(:each) do
    @heap = Containers::MaxHeap.new
  end
  
  describe "(empty)" do
  
    it "should return nil when getting the maximum" do
      @heap.max!.should eql(nil)
    end
    
    it "should let you insert and remove one item" do
      @heap.size.should eql(0)
      
      @heap.insert(1)
      @heap.size.should eql(1)
      
      @heap.max!.should eql(1)
      @heap.size.should eql(0)
    end
    
    it "should let you initialize with an array" do
      @heap = Containers::MaxHeap.new([1,2,3])
      @heap.size.should eql(3)
    end

  end
  
  describe "(non-empty)" do
    before(:each) do
      @random_array = []
      @num_items = 100
      @num_items.times { |x| @random_array << rand(@num_items) }
      @heap = Containers::MaxHeap.new(@random_array)
    end
    
    it "should display the correct size" do
      @heap.size.should eql(@num_items)
    end
    
    it "should be in max->min order" do
      ordered = []
      ordered << @heap.max! until @heap.size == 0
      
      ordered.should eql(@random_array.sort.reverse)
    end
    
    it "should let you merge with another heap" do
      numbers = [1,3,4,5]
      otherheap = Containers::MaxHeap.new(numbers)
      otherheap.size.should eql(4)
      @heap.merge!(otherheap)
      
      ordered = []
      ordered << @heap.max! until @heap.size == 0
      
      ordered.should eql( (@random_array + numbers).sort.reverse)
    end
    
    describe "min-heap" do
      it "should be in min->max order" do
        @heap = Containers::MinHeap.new(@random_array)
        ordered = []
        ordered << @heap.min! until @heap.size == 0

        ordered.should eql(@random_array.sort)
      end
    end
    
  end
  
end