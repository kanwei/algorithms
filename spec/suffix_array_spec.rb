$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty suffix array" do
  it "should not initialize with empty string" do
    lambda { Containers::SuffixArray.new("") }.should raise_error
  end
end

describe "non-empty suffix array" do
  before(:each) do
    @s_array = Containers::SuffixArray.new("abracadabra")
  end

  it "should has_substring? each possible substring" do
    @s_array.has_substring?("a").should be true
    @s_array.has_substring?("abra").should be true
    @s_array.has_substring?("abracadabra").should be true
    @s_array.has_substring?("acadabra").should be true
    @s_array.has_substring?("adabra").should be true
    @s_array.has_substring?("bra").should be true
    @s_array.has_substring?("bracadabra").should be true
    @s_array.has_substring?("cadabra").should be true
    @s_array.has_substring?("dabra").should be true
    @s_array.has_substring?("ra").should be true
    @s_array.has_substring?("racadabra").should be true
  end

  it "should not has_substring? substrings it does not have" do
    @s_array.has_substring?("nope").should be false
    @s_array.has_substring?(nil).should be false
  end

  it "should work with numbers (calls to_s)" do
    number = Containers::SuffixArray.new(123456789)
    number[1].should be true
    number.has_substring?(12).should be true
    number.has_substring?(13).should be false
  end
end
