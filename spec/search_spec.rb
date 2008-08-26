$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe Algorithms::Search do
  it "should binary search sorted arrays" do
    n = 1000
    @rand_array = Array.new(n) { rand(n) }.sort
    
    Algorithms::Search.binary_search(@rand_array, @rand_array.first).should eql(@rand_array.first)
    Algorithms::Search.binary_search(@rand_array, 999999).should be_nil
    Algorithms::Search.binary_search(@rand_array, nil).should be_nil
  end
  
  it "should use kmp_search to find substrings it has" do
    string = "ABC ABCDAB ABCDABCDABDE"
    Algorithms::Search.kmp_search(string, "ABCDABD").should eql(15)
    Algorithms::Search.kmp_search(string, "ABCDEF").should be_nil
    Algorithms::Search.kmp_search(string, nil).should be_nil
    Algorithms::Search.kmp_search(string, "").should be_nil
    Algorithms::Search.kmp_search(nil, "ABCD").should be_nil
  end
  
  it "should let you include Search in String to enable instance methods" do
    class String; include Algorithms::Search; end
    "ABC ABCDAB ABCDABCDABDE".kmp_search("ABCDABD").should eql(15)
  end
end