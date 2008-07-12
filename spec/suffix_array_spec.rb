require 'lib/containers/suffix_array'

describe Containers::SuffixArray do
  describe "(empty)" do
    it "should not initialize with empty string" do
      lambda { Containers::SuffixArray.new("") }.should raise_error
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @s_array = Containers::SuffixArray.new("abracadabra")
    end
  
    it "should has_substring? each possible substring" do
      @s_array.has_substring?("a").should be_true
      @s_array.has_substring?("abra").should be_true
      @s_array.has_substring?("abracadabra").should be_true
      @s_array.has_substring?("acadabra").should be_true
      @s_array.has_substring?("adabra").should be_true
      @s_array.has_substring?("bra").should be_true
      @s_array.has_substring?("bracadabra").should be_true
      @s_array.has_substring?("cadabra").should be_true
      @s_array.has_substring?("dabra").should be_true
      @s_array.has_substring?("ra").should be_true
      @s_array.has_substring?("racadabra").should be_true
    end
    
    it "should not has_substring? substrings it does not have" do
      @s_array.has_substring?("nope").should be_false
      @s_array.has_substring?(nil).should be_false
    end
    
    it "should work with numbers (calls to_s)" do
      number = Containers::SuffixArray.new(123456789)
      number[1].should be_true
      number.has_substring?(12).should be_true
      number.has_substring?(13).should be_false
    end
  end
end
