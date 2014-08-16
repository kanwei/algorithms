$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

shared_examples "(empty deque)" do
  it "should return nil when popping objects" do
    expect(@deque.pop_front).to be_nil
    expect(@deque.pop_back).to be_nil
  end

  it "should return a size of 1 when sent #push_front" do
    @deque.push_front(1)
    expect(@deque.size).to eql(1)
  end

  it "should return a size of 1 when sent #push_back" do
    @deque.push_back(1)
    expect(@deque.size).to eql(1)
  end

  it "should return nil when sent #front and #back" do
    expect(@deque.front).to be_nil
    expect(@deque.back).to be_nil
  end

  it "should be empty" do
    expect(@deque).to be_empty
  end

  it "should raise ArgumentError if passed more than one argument" do
    expect { @deque.class.send("new", Time.now, []) }.to raise_error
  end
end

shared_examples "(non-empty deque)" do
  before(:each) do
    @deque.push_back(10)
    @deque.push_back("10")
  end

  it "should return last pushed object with pop_back" do
    expect(@deque.pop_back).to eql("10")
    expect(@deque.pop_back).to eql(10)
  end

  it "should return first pushed object with pop_front" do
    expect(@deque.pop_front).to eql(10)
    expect(@deque.pop_front).to eql("10")
  end

  it "should return a size greater than 0" do
    expect(@deque.size).to eql(2)
  end

  it "should not be empty" do
    expect(@deque).not_to be_empty
  end

  it "should iterate in LIFO order with #each_backward" do
    arr = []
    @deque.each_backward { |obj| arr << obj }
    expect(arr).to eql(["10", 10])
  end

  it "should iterate in FIFO order with #each_forward" do
    arr = []
    @deque.each_forward { |obj| arr << obj }
    expect(arr).to eql([10, "10"])
  end

  it "should return nil after everything's popped" do
    @deque.pop_back
    @deque.pop_back
    expect(@deque.pop_back).to be_nil
    expect(@deque.front).to be_nil
  end
end

describe "empty rubydeque" do
  before(:each) do
    @deque = Containers::RubyDeque.new
  end
  it_should_behave_like "(empty deque)"
end

describe "full rubydeque" do
  before(:each) do
    @deque = Containers::RubyDeque.new
  end
  it_should_behave_like "(non-empty deque)"
end

begin
  Containers::CDeque
  describe "empty cdeque" do
    before(:each) do
      @deque = Containers::CDeque.new
    end
    it_should_behave_like "(empty deque)"
  end

  describe "full cdeque" do
    before(:each) do
      @deque = Containers::CDeque.new
    end
    it_should_behave_like "(non-empty deque)"
  end
rescue Exception
end
