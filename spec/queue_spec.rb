require 'lib/containers/queue'

describe Containers::Queue do
  before(:each) do
    @queue = Containers::Queue.new
  end
  
  describe "(empty)" do
    it "should return nil when sent #pop" do
      @queue.pop.should eql(nil)
    end

    it "should return a size of 1 when sent #push" do
      @queue.push(1)
      @queue.size.should eql(1)
    end
    
    it "should return nil when sent #next" do
      @queue.next.should eql(nil)
    end
    
    it "should return empty?" do
      @queue.empty?.should eql(true)
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @queue.push(10)
      @queue.push("10")
    end
    
    it "should return first pushed object" do
      @queue.pop.should eql(10)
    end
    
    it "should return the size" do
      @queue.size.should eql(2)
    end
    
    it "should not return empty?" do
      @queue.empty?.should eql(false)
    end
    
    it "should iterate in FIFO order" do
      arr = []
      @queue.each { |obj| arr << obj }
      arr.should eql([10, "10"])
    end
    
    it "should return nil after all gets" do
      @queue.pop
      @queue.pop
      @queue.pop.should eql(nil)
      @queue.next.should eql(nil)
    end
    
  end
  
end