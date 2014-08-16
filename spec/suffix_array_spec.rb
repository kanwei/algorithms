$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty suffix array" do
  it "should not initialize with empty string" do
    expect { Containers::SuffixArray.new("") }.to raise_error
  end
end

describe "non-empty suffix array" do
  before(:each) do
    @s_array = Containers::SuffixArray.new("abracadabra")
  end

  it "should has_substring? each possible substring" do
    expect(@s_array.has_substring?("a")).to be true
    expect(@s_array.has_substring?("abra")).to be true
    expect(@s_array.has_substring?("abracadabra")).to be true
    expect(@s_array.has_substring?("acadabra")).to be true
    expect(@s_array.has_substring?("adabra")).to be true
    expect(@s_array.has_substring?("bra")).to be true
    expect(@s_array.has_substring?("bracadabra")).to be true
    expect(@s_array.has_substring?("cadabra")).to be true
    expect(@s_array.has_substring?("dabra")).to be true
    expect(@s_array.has_substring?("ra")).to be true
    expect(@s_array.has_substring?("racadabra")).to be true
  end

  it "should not has_substring? substrings it does not have" do
    expect(@s_array.has_substring?("nope")).to be false
    expect(@s_array.has_substring?(nil)).to be false
  end

  it "should work with numbers (calls to_s)" do
    number = Containers::SuffixArray.new(123456789)
    expect(number[1]).to be true
    expect(number.has_substring?(12)).to be true
    expect(number.has_substring?(13)).to be false
  end
end
