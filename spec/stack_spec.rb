$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty stack" do
  before(:each) do
    @stack = Containers::Stack.new
  end

  it "should return nil when sent #pop" do
    expect(@stack.pop).to be_nil
  end

  it "should return a size of 1 when sent #push" do
    @stack.push(1)
    expect(@stack.size).to eql(1)
  end

  it "should return nil when sent #next" do
    expect(@stack.next).to be_nil
  end

  it "should return empty?" do
    expect(@stack.empty?).to be true
  end
end

describe "non-empty stack" do
  before(:each) do
    @stack = Containers::Stack.new
    @stack.push(10)
    @stack.push("10")
  end

  it "should return last pushed object" do
    expect(@stack.pop).to eql("10")
  end

  it "should return the size" do
    expect(@stack.size).to eql(2)
  end

  it "should not return empty?" do
    expect(@stack.empty?).to be false
  end


  it "should iterate in LIFO order" do
    arr = []
    @stack.each { |obj| arr << obj }
    expect(arr).to eql(["10", 10])
  end

  it "should return nil after all pops" do
    @stack.pop
    @stack.pop
    expect(@stack.pop).to be_nil
    expect(@stack.next).to be_nil
  end

end
