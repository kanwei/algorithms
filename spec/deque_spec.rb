require 'lib/containers/deque'

describe Containers::Deque do
  before(:each) do
    @deque = Containers::Deque.new
  end
  
  describe "(empty)" do
    it "should return nil when popping objects" do
      @deque.pop_front.should be_nil
      @deque.pop_back.should be_nil
    end

    it "should return a size of 1 when sent #push_front" do
      @deque.push_front(1)
      @deque.size.should eql(1)
    end
    
    it "should return a size of 1 when sent #push_back" do
      @deque.push_back(1)
      @deque.size.should eql(1)
    end
    
    it "should return nil when sent #front and #back" do
      @deque.front.should be_nil
      @deque.back.should be_nil
    end
    
    it "should be empty" do
      @deque.should be_empty
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @deque.push_back(10)
      @deque.push_back("10")
    end
    
    it "should return last pushed object with pop_back" do
      @deque.pop_back.should eql("10")
      @deque.pop_back.should eql(10)
    end
    
    it "should return first pushed object with pop_front" do
      @deque.pop_front.should eql(10)
      @deque.pop_front.should eql("10")
    end
    
    it "should return a size greater than 0" do
      @deque.size.should eql(2)
    end
    
    it "should not be empty" do
      @deque.should_not be_empty
    end
        
    it "should iterate in LIFO order with #each_backward" do
      arr = []
      @deque.each_backward { |obj| arr << obj }
      arr.should eql(["10", 10])
    end
    
    it "should iterate in FIFO order with #each_forward" do
      arr = []
      @deque.each_forward { |obj| arr << obj }
      arr.should eql([10, "10"])
    end
    
    it "should return nil after everything's popped" do
      @deque.pop_back
      @deque.pop_back
      @deque.pop_back.should be_nil
      @deque.front.should be_nil
    end
  end
end
