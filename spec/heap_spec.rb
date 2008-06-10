require 'lib/algorithms'
require 'benchmark'
include Benchmark

describe DS::Heap do
  before(:each) do
    @heap = DS::Heap.new
  end
  
  describe "(empty)" do
  
    it "should return nil when getting the maximum" do
      @heap.get_max!.should eql(nil)
    end
    
    it "should let you insert" do
      @heap.size.should eql(0)
      
      @heap.insert(1)
      @heap.size.should eql(1)
      
      @heap.get_max!.should eql(1)
      @heap.size.should eql(0)
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @random_array = []
      @num_items = 1000
      @num_items.times { |x| @random_array << rand(@num_items) }
      @heap = DS::Heap.new
      @random_array.each { |n| @heap.insert(n) }
    end
    
    it "should be correct!" do
      ordered = []
      until @heap.size == 0
        ordered << @heap.get_max!
      end
      
      ordered.should eql(@random_array.sort.reverse)
    end
    
    it "should be faster than the naive approach of finding maximum in an array" do
      benchmark do |x|
        x.report("Array#max: ") do
          @num_items.times { @random_array.delete_at(@random_array.index(@random_array.max)) }
        end
        x.report("Heap: ") do
          @num_items.times { @heap.get_max! }
        end
      end
    end
    
  end
  
end