require 'lib/algorithms'

describe DS::Heap do
  before(:each) do
    @heap = DS::Heap.new
  end
  
  describe "(empty)" do
    it "should complain when sent #peek" do
      lambda { @heap.peek }.should raise_error(HeapEmptyError)
    end

    it "should complain when sent #find_min" do
      lambda { @heap.find_min }.should raise_error(HeapEmptyError)
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @heap.add(10)
    end
  end
  
end