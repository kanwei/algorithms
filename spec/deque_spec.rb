require 'lib/containers/deque'

describe Containers::Deque do
  before(:each) do
    @deque = Containers::Deque.new
  end
  
  describe "(empty)" do
    it "should return nil when popping objects" do
      @deque.pop_front.should eql(nil)
      @deque.pop_back.should eql(nil)
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
      @deque.front.should eql(nil)
      @deque.back.should eql(nil)
    end
    
    it "should return empty?" do
      @deque.empty?.should eql(true)
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
    
    it "should return the size" do
      @deque.size.should eql(2)
    end
    
    it "should not be empty?" do
      @deque.empty?.should eql(false)
    end
        
    it "should iterate in LIFO order" do
      arr = []
      @deque.each_backward { |obj| arr << obj }
      arr.should eql(["10", 10])
    end
    
    it "should iterate in FIFO order" do
      arr = []
      @deque.each_forward { |obj| arr << obj }
      arr.should eql([10, "10"])
    end
    
    it "should return nil after all pops" do
      @deque.pop_back
      @deque.pop_back
      @deque.pop_back.should eql(nil)
      @deque.front.should eql(nil)
    end
    
  end
  
end