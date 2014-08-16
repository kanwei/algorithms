$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe Containers::Heap do
  before(:each) do
    @heap = Containers::MaxHeap.new
  end
  
  it "should not let you merge with non-heaps" do
    expect { @heap.merge!(nil) }.to raise_error
    expect { @heap.merge!([]) }.to raise_error
  end
  
  describe "(empty)" do
  
    it "should return nil when getting the maximum" do
      expect(@heap.max!).to be_nil
    end
    
    it "should let you insert and remove one item" do
      expect(@heap.size).to eql(0)
      
      @heap.push(1)
      expect(@heap.size).to eql(1)
      
      expect(@heap.max!).to eql(1)
      expect(@heap.size).to eql(0)
    end
    
    it "should let you initialize with an array" do
      @heap = Containers::MaxHeap.new([1,2,3])
      expect(@heap.size).to eql(3)
    end

  end
  
  describe "(non-empty)" do
    before(:each) do
      @random_array = []
      @num_items = 100
      @num_items.times { @random_array << rand(@num_items) }
      @heap = Containers::MaxHeap.new(@random_array)
    end
    
    it "should display the correct size" do
      expect(@heap.size).to eql(@num_items)
    end
    
    it "should have a next value" do
      expect(@heap.next).to be_truthy
      expect(@heap.next_key).to be_truthy
    end
    
    it "should delete random keys" do
      expect(@heap.delete(@random_array[0])).to eql(@random_array[0])
      expect(@heap.delete(@random_array[1])).to eql(@random_array[1])
      ordered = []
      ordered << @heap.max! until @heap.empty?
      expect(ordered).to eql( @random_array[2..-1].sort.reverse )
    end
    
    it "should delete all keys" do
      ordered = []
      @random_array.size.times do |t|
        ordered << @heap.delete(@random_array[t])
      end
      expect(@heap).to be_empty
      expect(ordered).to eql( @random_array )
    end

    it "should be in max->min order" do
      ordered = []
      ordered << @heap.max! until @heap.empty?
      
      expect(ordered).to eql(@random_array.sort.reverse)
    end
    
    it "should change certain keys" do
      numbers = [1,2,3,4,5,6,7,8,9,10,100,101]
      heap = Containers::MinHeap.new(numbers)
      heap.change_key(101, 50)
      heap.pop
      heap.pop
      heap.change_key(8, 0)
      ordered = []
      ordered << heap.min! until heap.empty?
      expect(ordered).to eql( [8,3,4,5,6,7,9,10,101,100] )
    end
    
    it "should not delete keys it doesn't have" do
      expect(@heap.delete(:nonexisting)).to be_nil
      expect(@heap.size).to eql(@num_items)
    end
    
    it "should delete certain keys" do
      numbers = [1,2,3,4,5,6,7,8,9,10,100,101]
      heap = Containers::MinHeap.new(numbers)
      heap.delete(5)
      heap.pop
      heap.pop
      heap.delete(100)
      ordered = []
      ordered << heap.min! until heap.empty?
      expect(ordered).to eql( [3,4,6,7,8,9,10,101] )
    end
    
    it "should let you merge with another heap" do
      numbers = [1,2,3,4,5,6,7,8]
      otherheap = Containers::MaxHeap.new(numbers)
      expect(otherheap.size).to eql(8)
      @heap.merge!(otherheap)
      
      ordered = []
      ordered << @heap.max! until @heap.empty?
      
      expect(ordered).to eql( (@random_array + numbers).sort.reverse)
    end
    
    describe "min-heap" do
      it "should be in min->max order" do
        @heap = Containers::MinHeap.new(@random_array)
        ordered = []
        ordered << @heap.min! until @heap.empty?
    
        expect(ordered).to eql(@random_array.sort)
      end
    end
    
  end
  
end
