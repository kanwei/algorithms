require 'lib/containers/stack'

describe Containers::Stack do
  before(:each) do
    @stack = Containers::Stack.new
  end
  
  describe "(empty)" do
    it "should return nil when sent #pop" do
      @stack.pop.should eql(nil)
    end

    it "should return a size of 1 when sent #push" do
      @stack.push(1).size.should eql(1)
    end
    
    it "should return nil when sent #next" do
      @stack.next.should eql(nil)
    end
    
    it "should return empty?" do
      @stack.empty?.should eql(true)
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @stack.push(10)
      @stack.push("10")
    end
    
    it "should return last pushed object" do
      @stack.pop.should eql("10")
    end
    
    it "should return the size" do
      @stack.size.should eql(2)
    end
    
    it "should not return empty?" do
      @stack.empty?.should eql(false)
    end
    
    it "should return nil after all pops" do
      @stack.pop
      @stack.pop
      @stack.pop.should eql(nil)
      @stack.next.should eql(nil)
    end
    
  end
  
end