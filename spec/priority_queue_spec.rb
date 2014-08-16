$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe Containers::PriorityQueue do
  before(:each) do
    @q = Containers::PriorityQueue.new
  end
  
  describe "(empty priority queue)" do
    it "should return 0 for size and be empty" do
      expect(@q.size).to eql(0)
      expect(@q).to be_empty
    end
    
    it "should not return anything" do
      expect(@q.next).to be_nil
      expect(@q.pop).to be_nil
      expect(@q.delete(1)).to be_nil
      expect(@q.has_priority?(1)).to be false
    end
    
    it "should give the correct size when adding items" do
      20.times do |i|
        expect(@q.size).to eql(i)
        @q.push(i, i)
      end
      10.times do |i|
        expect(@q.size).to eql(20-i)
        @q.pop
      end
      10.times do |i|
        expect(@q.size).to eql(i+10)
        @q.push(i, i)
      end
      @q.delete(5)
      expect(@q.size).to eql(19)
    end
  end
  
  describe "(non-empty priority queue)" do
    before(:each) do
      @q.push("Alaska", 50)
      @q.push("Delaware", 30)
      @q.push("Georgia", 35)
    end
    
    it "should next/pop the highest priority" do
      expect(@q.next).to eql("Alaska")
      expect(@q.size).to eql(3)
      expect(@q.pop).to eql("Alaska")
      expect(@q.size).to eql(2)
    end
    
    it "should not be empty" do
      expect(@q).not_to be_empty
    end
    
    it "should has_priority? priorities it has" do
      expect(@q.has_priority?(50)).to be true
      expect(@q.has_priority?(10)).to be false
    end      
    
    it "should return nil after popping everything" do
      3.times do 
        @q.pop
      end
      expect(@q.pop).to be_nil
    end
    
    it "should delete things it has and not things it doesn't" do
      expect(@q.delete(50)).to eql("Alaska")
      expect(@q.delete(10)).to eql(nil)
    end
  end
end
