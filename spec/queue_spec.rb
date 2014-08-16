$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty queue" do
  before(:each) do
    @queue = Containers::Queue.new
  end


  it "should return nil when sent #pop" do
    expect(@queue.pop).to be_nil
  end

  it "should return a size of 1 when sent #push" do
    @queue.push(1)
    expect(@queue.size).to eql(1)
  end

  it "should return nil when sent #next" do
    expect(@queue.next).to be_nil
  end

  it "should return empty?" do
    expect(@queue.empty?).to be true
  end
end

describe "non-empty queue" do
  before(:each) do
    @queue = Containers::Queue.new
    @queue.push(10)
    @queue.push("10")
  end

  it "should return first pushed object" do
    expect(@queue.pop).to eql(10)
  end

  it "should return the size" do
    expect(@queue.size).to eql(2)
  end

  it "should not return empty?" do
    expect(@queue.empty?).to be false
  end

  it "should iterate in FIFO order" do
    arr = []
    @queue.each { |obj| arr << obj }
    expect(arr).to eql([10, "10"])
  end

  it "should return nil after all gets" do
    2.times do
      @queue.pop
    end
    expect(@queue.pop).to be_nil
    expect(@queue.next).to be_nil
  end

end
