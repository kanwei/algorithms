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
      @s_array.has_substring?("a").should eql(true)
      @s_array.has_substring?("abra").should eql(true)
      @s_array.has_substring?("abracadabra").should eql(true)
      @s_array.has_substring?("acadabra").should eql(true)
      @s_array.has_substring?("adabra").should eql(true)
      @s_array.has_substring?("bra").should eql(true)
      @s_array.has_substring?("bracadabra").should eql(true)
      @s_array.has_substring?("cadabra").should eql(true)
      @s_array.has_substring?("dabra").should eql(true)
      @s_array.has_substring?("ra").should eql(true)
      @s_array.has_substring?("racadabra").should eql(true)
    end
    
    it "should not has_substring? substrings it does not have" do
      @s_array.has_substring?("nope").should eql(false)
      @s_array.has_substring?(nil).should eql(false)
    end
    
    it "should work with numbers (calls to_s)" do
      number = Containers::SuffixArray.new(123456789)
      number[1].should eql(true)
      number.has_substring?(12).should eql(true)
      number.has_substring?(13).should eql(false)
    end
  end
end