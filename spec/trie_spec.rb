$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe "empty trie" do
  before(:each) do
    @trie = Containers::Trie.new
  end

  it "should not get or has_key?" do
    expect(@trie.get("anything")).to be_nil
    expect(@trie.has_key?("anything")).to be false
  end

  it "should not have longest_prefix or match wildcards" do
    expect(@trie.wildcard("an*thing")).to eql([])
    expect(@trie.longest_prefix("an*thing")).to eql("")
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
    expect(@trie.has_key?("Hello")).to be true
    expect(@trie.has_key?("Hello, brother")).to be true
    expect(@trie.has_key?("Hello, bob")).to be true
  end

  it "should not has_key? keys it doesn't have" do
    expect(@trie.has_key?("Nope")).to be false
  end

  it "should get values" do
    expect(@trie.get("Hello")).to eql("World")
  end

  it "should overwrite values" do
    @trie.push("Hello", "John")
    expect(@trie.get("Hello")).to eql("John")
  end

  it "should return longest prefix" do
    expect(@trie.longest_prefix("Hello, brandon")).to eql("Hello")
    expect(@trie.longest_prefix("Hel")).to eql("")
    expect(@trie.longest_prefix("Hello")).to eql("Hello")
    expect(@trie.longest_prefix("Hello, bob")).to eql("Hello, bob")
  end

  it "should match wildcards" do
    expect(@trie.wildcard("H*ll.")).to eql(["Hello", "Hilly"])
    expect(@trie.wildcard("Hel")).to eql([])
  end
end
