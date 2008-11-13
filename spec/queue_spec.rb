$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty queue" do
  before(:each) do
    @queue = Containers::Queue.new
  end


  it "should return nil when sent #pop" do
    @queue.pop.should be_nil
  end

  it "should return a size of 1 when sent #push" do
    @queue.push(1)
    @queue.size.should eql(1)
  end

  it "should return nil when sent #next" do
    @queue.next.should be_nil
  end

  it "should return empty?" do
    @queue.empty?.should be_true
  end
end

describe "non-empty queue" do
  before(:each) do
    @queue = Containers::Queue.new
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
    @queue.empty?.should be_false
  end

  it "should iterate in FIFO order" do
    arr = []
    @queue.each { |obj| arr << obj }
    arr.should eql([10, "10"])
  end

  it "should return nil after all gets" do
    2.times do
      @queue.pop
    end
    @queue.pop.should be_nil
    @queue.next.should be_nil
  end

end
