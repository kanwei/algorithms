require 'lib/containers/trie'

describe Containers::Trie do
  describe "(empty)" do
    before(:each) do
      @trie = Containers::Trie.new
    end
    
    it "should not get or has_key?" do
      @trie.get("anything").should be_nil
      @trie.has_key?("anything").should be_false
    end
    
    it "should not have longest_prefix or match wildcards" do
      @trie.wildcard("an*thing").should eql([])
      @trie.longest_prefix("an*thing").should eql("")
    end
  end
  
  describe "(non-empty)" do
    before(:each) do
      @trie = Containers::Trie.new
      @trie.push("Hello", "World")
      @trie.push("Hilly", "World")
      @trie.push("Hello, brother", "World")
      @trie.push("Hello, bob", "World")
    end
  
    it "should has_key? keys it has" do
      @trie.has_key?("Hello").should be_true
      @trie.has_key?("Hello, brother").should be_true
      @trie.has_key?("Hello, bob").should be_true
    end
    
    it "should not has_key? keys it doesn't have" do
      @trie.has_key?("Nope").should be_false
    end
    
    it "should get values" do
      @trie.get("Hello").should eql("World")
    end
    
    it "should overwrite values" do
      @trie.push("Hello", "John")
      @trie.get("Hello").should eql("John")
    end
    
    it "should return longest prefix" do
      @trie.longest_prefix("Hello, brandon").should eql("Hello")
      @trie.longest_prefix("Hel").should eql("")
      @trie.longest_prefix("Hello").should eql("Hello")
      @trie.longest_prefix("Hello, bob").should eql("Hello, bob")
    end
    
    it "should match wildcards" do
      @trie.wildcard("H*ll.").should eql(["Hello", "Hilly"])
      @trie.wildcard("Hel").should eql([])
    end
  end
end
