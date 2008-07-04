require 'lib/containers/priority_queue'
require 'lib/CPriorityQueue'

describe Containers::RubyPriorityQueue do
  before(:each) do
    @q = Containers::RubyPriorityQueue.new
  end
  
  describe "(empty)" do

  end
  
  describe "(non-empty)" do
    it "should give the correct length/size" do
      20.times do | i |
        @q.length.should eql(i)
        @q[i] = i
      end
      10.times do | i |
        @q.length.should eql(20-i)
        @q.delete_min
      end
      10.times do | i |
        @q.length.should eql(i+10)
        @q[i] = i
      end
      @q.delete(5)
      @q.length.should eql(19)
    end
  end
  
end