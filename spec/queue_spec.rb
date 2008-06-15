require 'lib/algorithms'

describe Containers::Queue do
  before(:each) do
    @queue = Containers::Queue.new
  end
  
  describe "(empty)" do
    it "should return nil when sent #get" do
      @queue.get.should eql(nil)
    end

    it "should return a size of 1 when sent #put" do
      @queue.put(1).size.should eql(1)
    end
    
    it "should return nil when peeked" do
      @queue.peek.should eql(nil)
    end
    
    it "should return empty?" do
      @queue.empty?.should eql(true)
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @queue.put(10)
      @queue.put("10")
    end
    
    it "should return first put object" do
      @queue.get.should eql(10)
    end
    
    it "should return the size" do
      @queue.size.should eql(2)
    end
    
    it "should not return empty?" do
      @queue.empty?.should eql(false)
    end
    
    it "should return nil after all gets" do
      @queue.get
      @queue.get
      @queue.get.should eql(nil)
      @queue.peek.should eql(nil)
    end
    
  end
  
end