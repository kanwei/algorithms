$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

if defined? Algorithms::String
  describe "string algorithms" do
    it "should do levenshtein distance" do    
      expect(Algorithms::String.levenshtein_dist("Hello", "Hel")).to eql(2)
      expect(Algorithms::String.levenshtein_dist("Hello", "")).to eql(5)
      expect(Algorithms::String.levenshtein_dist("", "Hello")).to eql(5)
      expect(Algorithms::String.levenshtein_dist("Hello", "Hello")).to eql(0)
      expect(Algorithms::String.levenshtein_dist("Hello", "ello")).to eql(1)
      expect(Algorithms::String.levenshtein_dist("Hello", "Mello")).to eql(1)
    end
  end
end