$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

class String; include Algorithms::Search; end

describe "search algorithms" do
  it "should binary search sorted arrays" do
    n = 1000
    @rand_array = Array.new(n) { rand(n) }.sort
    
    expect(Algorithms::Search.binary_search(@rand_array, @rand_array.first)).to eql(@rand_array.first)
    expect(Algorithms::Search.binary_search(@rand_array, 999999)).to be_nil
    expect(Algorithms::Search.binary_search(@rand_array, nil)).to be_nil
  end
  
  it "should use kmp_search to find substrings it has" do
    string = "ABC ABCDAB ABCDABCDABDE"
    expect(Algorithms::Search.kmp_search(string, "ABCDABD")).to eql(15)
    expect(Algorithms::Search.kmp_search(string, "ABCDEF")).to be_nil
    expect(Algorithms::Search.kmp_search(string, nil)).to be_nil
    expect(Algorithms::Search.kmp_search(string, "")).to be_nil
    expect(Algorithms::Search.kmp_search(nil, "ABCD")).to be_nil
  end

  it "should use kmp_search to find all substrings if all_indices is true" do
    string = "ABC ABCDAB ABCDABCDABDE"
    expect(Algorithms::Search.kmp_search(string, "ABC", all_indices: true)).to eql([0, 4, 11, 15])
    expect(Algorithms::Search.kmp_search(string, "ABCDEF", all_indices: true)).to be_nil
    expect(Algorithms::Search.kmp_search(string, nil, all_indices: true)).to be_nil
    expect(Algorithms::Search.kmp_search(string, "", all_indices: true)).to be_nil
    expect(Algorithms::Search.kmp_search(nil, "ABCD", all_indices: true)).to be_nil
  end

  it "should let you include Search in String to enable instance methods" do
    expect("ABC ABCDAB ABCDABCDABDE".kmp_search("ABCDABD")).to eql(15)
  end

  it "should let you include Search in String to enable instance methods with all_indices set to true" do
    expect("ABC ABCDAB ABCDABCDABDE".kmp_search("ABC", all_indices: true)).to eql([0, 4, 11, 15])
  end
end