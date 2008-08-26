=begin rdoc
    This module implements search algorithms. Documentation is provided for each algorithm.
    
=end
module Algorithms::Search
  # Binary Search: This search finds an item in log(n) time provided that the container is already sorted.
  # The method returns the item if it is found, or nil if it is not. If there are duplicates, the first one
  # found is returned, and this is not guaranteed to be the smallest or largest item.
  #
  # Complexity: O(lg N)
  # 
  #   Algorithms::Search.binary_search([1, 2, 3], 1) #=> 1
  #   Algorithms::Search.binary_search([1, 2, 3], 4) #=> nil
  def self.binary_search(container, item)
    return nil if item.nil?
    low = 0
    high = container.size - 1
    while low <= high
      mid = (low + high) / 2
      val = container[mid]
      if val > item
        high = mid - 1
      elsif val < item
        low = mid + 1
      else
        return val
      end
    end
    nil
  end
  
  # Knuth-Morris-Pratt Algorithm substring search algorithm: Efficiently finds the starting position of a 
  # substring in a string. The algorithm calculates the best position to resume searching from if a failure
  # occurs.
  # 
  # The method returns the index of the starting position in the string where the substring is found. If there
  # is no match, nil is returned.
  #
  # Complexity: O(n + k), where n is the length of the string and k is the length of the substring.
  #
  #   Algorithms::Search.kmp_search("ABC ABCDAB ABCDABCDABDE", "ABCDABD") #=> 15
  #   Algorithms::Search.kmp_search("ABC ABCDAB ABCDABCDABDE", "ABCDEF") #=> nil
  def self.kmp_search(string, substring)
    return nil if string.nil? or substring.nil?
    
    # create failure function table
    pos = 2
    cnd = 0
    failure_table = [-1, 0]
    while pos < substring.length
      if substring[pos - 1] == substring[cnd]
        failure_table[pos] = cnd + 1
        pos += 1
        cnd += 1
      elsif cnd > 0
        cnd = failure_table[cnd]
      else
        failure_table[pos] = 0
        pos += 1
      end
    end

    m = i = 0
    while m + i < string.length
      if substring[i] == string[m + i]
        i += 1
        return m if i == substring.length
      else
        m = m + i - failure_table[i]
        i = failure_table[i] if i > 0
      end
    end
    return nil
  end
  
  # Allows kmp_search to be called as an instance method in classes that include the Search module.
  #
  #   class String; include Algorithms::Search; end
  #   "ABC ABCDAB ABCDABCDABDE".kmp_search("ABCDABD") #=> 15
  def kmp_search(substring)
    Algorithms::Search.kmp_search(self, substring)
  end
  
end
