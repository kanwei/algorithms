$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

class String; include Algorithms::Search; end

describe "search algorithms" do
  it "should binary search sorted arrays" do
    @rand_array = Array.new(1000) { |i| i }

    expect(Algorithms::Search.binary_search(@rand_array, @rand_array.first)).to eql(@rand_array.first)
    expect(Algorithms::Search.binary_search(@rand_array, 999999)).to be_nil
    expect { Algorithms::Search.binary_search(@rand_array, nil) }.to raise_error(ArgumentError)

    expect(Algorithms::Search.binary_search_index(@rand_array, @rand_array.first)).to eql(0)
    expect(Algorithms::Search.binary_search_index(@rand_array, 999_999)).to be_nil
    expect { Algorithms::Search.binary_search_index(@rand_array, nil) }.to raise_error(ArgumentError)
  end

  it "should use kmp_search to find substrings it has" do
    string = "ABC ABCDAB ABCDABCDABDE"
    expect(Algorithms::Search.kmp_search(string, "ABCDABD")).to eql(15)
    expect(Algorithms::Search.kmp_search(string, "ABCDEF")).to be_nil
    expect(Algorithms::Search.kmp_search(string, nil)).to be_nil
    expect(Algorithms::Search.kmp_search(string, "")).to be_nil
    expect(Algorithms::Search.kmp_search(nil, "ABCD")).to be_nil
  end

  it "should let you include Search in String to enable instance methods" do
    expect("ABC ABCDAB ABCDABCDABDE".kmp_search("ABCDABD")).to eql(15)
  end
end
