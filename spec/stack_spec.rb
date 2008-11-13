$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty stack" do
  before(:each) do
    @stack = Containers::Stack.new
  end

  it "should return nil when sent #pop" do
    @stack.pop.should be_nil
  end

  it "should return a size of 1 when sent #push" do
    @stack.push(1)
    @stack.size.should eql(1)
  end

  it "should return nil when sent #next" do
    @stack.next.should be_nil
  end

  it "should return empty?" do
    @stack.empty?.should be_true
  end
end

describe "non-empty stack" do
  before(:each) do
    @stack = Containers::Stack.new
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
    @stack.empty?.should be_false
  end


  it "should iterate in LIFO order" do
    arr = []
    @stack.each { |obj| arr << obj }
    arr.should eql(["10", 10])
  end

  it "should return nil after all pops" do
    @stack.pop
    @stack.pop
    @stack.pop.should be_nil
    @stack.next.should be_nil
  end

end
