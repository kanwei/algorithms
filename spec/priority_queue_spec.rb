$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty priority queue" do
  before(:each) do
    @q = Containers::PriorityQueue.new
  end

  it "should return 0 for size and be empty" do
    @q.size.should eql(0)
    @q.should be_empty
  end

  it "should not return anything" do
    @q.next.should be_nil
    @q.pop.should be_nil
    @q.delete(1).should be_nil
    @q.has_priority?(1).should be_false
  end

  it "should give the correct size when adding items" do
    20.times do |i|
      @q.size.should eql(i)
      @q.push(i, i)
    end
    10.times do |i|
      @q.size.should eql(20-i)
      @q.pop
    end
    10.times do |i|
      @q.size.should eql(i+10)
      @q.push(i, i)
    end
    @q.delete(5)
    @q.size.should eql(19)
  end
end

describe "non-empty priority queue" do
  before(:each) do
    @q = Containers::PriorityQueue.new
    @q.push("Alaska", 50)
    @q.push("Delaware", 30)
    @q.push("Georgia", 35)
  end

  it "should next/pop the highest priority" do
    @q.next.should eql("Alaska")
    @q.size.should eql(3)
    @q.pop.should eql("Alaska")
    @q.size.should eql(2)
  end

  it "should not be empty" do
    @q.should_not be_empty
  end

  it "should has_priority? priorities it has" do
    @q.has_priority?(50).should be_true
    @q.has_priority?(10).should be_false
  end      

  it "should return nil after popping everything" do
    3.times do 
      @q.pop
    end
    @q.pop.should be_nil
  end

  it "should delete things it has and not things it doesn't" do
    @q.delete(50).should eql("Alaska")
    @q.delete(10).should eql(nil)
  end

end
