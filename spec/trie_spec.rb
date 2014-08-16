$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty trie" do
  before(:each) do
    @trie = Containers::Trie.new
  end

  it "should not get or has_key?" do
    @trie.get("anything").should be_nil
    @trie.has_key?("anything").should be false
  end

  it "should not have longest_prefix or match wildcards" do
    @trie.wildcard("an*thing").should eql([])
    @trie.longest_prefix("an*thing").should eql("")
  end
end

describe "non-empty trie" do
  before(:each) do
    @trie = Containers::Trie.new
    @trie.push("Hello", "World")
    @trie.push("Hilly", "World")
    @trie.push("Hello, brother", "World")
    @trie.push("Hello, bob", "World")
  end

  it "should has_key? keys it has" do
    @trie.has_key?("Hello").should be true
    @trie.has_key?("Hello, brother").should be true
    @trie.has_key?("Hello, bob").should be true
  end

  it "should not has_key? keys it doesn't have" do
    @trie.has_key?("Nope").should be false
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
