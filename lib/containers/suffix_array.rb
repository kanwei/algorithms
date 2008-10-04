=begin rdoc
    A suffix array enables fast substring search of a given string. An array of all possible substrings
    is constructed and stored, and a binary search is then done to find a desired substring among those
    stored. While more storage (and thus memory) is needed to create the SuffixArray, the advantage is
    that substrings can be found in O(m log n) time, where m is the length of the substring to search for
    and n is the total number of substrings.

=end
class Containers::SuffixArray
  # Creates a new SuffixArray with a given string. Object of any class implementing a #to_s method can
  # be passed in, such as integers.
  #
  # Complexity: O(n^2 log n)
  #
  #   s_array = Containers::SuffixArray("abracadabra")
  #   s_array["abra"] #=> true
  #
  #   number = Containers::SuffixArray(1234567)
  #   number[1] #=> true
  #   number[13] #=> false 
  def initialize(string)
    string = string.to_s
    raise ArgumentError, "SuffixArray needs to be initialized with a non-empty string" if string.empty?
    @original_string = string
    @suffixes = []
    string.length.times do |i|
      @suffixes << string[i..-1]
    end

    # Sort the suffixes in ascending order
    @suffixes.sort! { |x, y| x <=> y }
  end
  
  # Returns true if the substring occurs in the string, false otherwise.
  #
  # Complexity: O(m + log n)
  #
  #   s_array = Containers::SuffixArray.new("abracadabra")
  #   s_array.has_substring?("a") #=> true
  #   s_array.has_substring?("abra") #=> true
  #   s_array.has_substring?("abracadabra") #=> true
  #   s_array.has_substring?("acadabra") #=> true
  #   s_array.has_substring?("adabra") #=> true
  #   s_array.has_substring?("bra") #=> true
  #   s_array.has_substring?("bracadabra") #=> true
  #   s_array.has_substring?("cadabra") #=> true
  #   s_array.has_substring?("dabra") #=> true
  #   s_array.has_substring?("ra") #=> true
  #   s_array.has_substring?("racadabra") #=> true
  #   s_array.has_substring?("nope") #=> false
  def has_substring?(substring)
    substring = substring.to_s
    return false if substring.empty?
    substring_length = substring.length-1
    l, r = 0, @suffixes.size-1
    while(l <= r)
      mid = (l + r) / 2
      suffix = @suffixes[mid][0..substring_length]
      case substring <=> suffix
      when 0 then return true
      when 1 then l = mid + 1
      when -1 then r = mid - 1
      end
    end
    return false
  end
  alias_method :[], :has_substring?
end