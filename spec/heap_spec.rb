$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

include Comparable

class Book
  attr_reader :title, :year_published

  def initialize(title, year_published)
    @title = title
    @year_published = year_published
  end

  def <=>(other)
    return nil unless other.is_a?(Book)

    # 1. Compare by year first
    year_comparison = self.year_published <=> other.year_published

    # 2. If years are different, return that comparison result
    return year_comparison unless year_comparison == 0

    # 3. If years are the same (tie), compare by title alphabetically
    #    (Ensure title comparison returns -1, 0, or 1)
    self.title <=> other.title
  end


  def to_s
    "\"#{title}\" (#{year_published})" # Simplified for test output
  end

  # Add an equality method for clearer test failures if needed,
  # though <=> returning 0 handles equality for sorting/heap purposes.
  def ==(other)
    other.is_a?(Book) &&
      self.title == other.title &&
      self.year_published == other.year_published
  end
  alias eql? ==

  def hash
    [title, year_published].hash
  end

end

describe ::Containers::Heap do

  # --- Test Data Setup ---
  let!(:book_1932) { Book.new("Brave New World", 1932) }
  let!(:book_1949) { Book.new("1984", 1949) }
  let!(:book_1951a) { Book.new("Foundation", 1951) }
  # Add another book from the same year to test handling of equal priority items
  let!(:book_1951b) { Book.new("The Illustrated Man", 1951) }
  let!(:book_1965) { Book.new("Dune", 1965) }
  let!(:book_1989) { Book.new("Hyperion", 1989) }

  # Use shuffle to ensure tests don't depend on insertion order
  let(:books) { [book_1965, book_1951a, book_1989, book_1949, book_1932, book_1951b].shuffle }

  let(:expected_min_order) { books.sort }

  let(:expected_max_order) { books.sort.reverse }

  context "Min-Heap (using default <=> via Comparable)" do
    # Initialize heap with books; it should use Book#<=> by default
    let(:min_heap) { ::Containers::Heap.new(books) }

    it "initializes with the correct size" do
      expect(min_heap.size).to eq(books.size)
      expect(min_heap.empty?).to be false
    end

    it "gets the next minimum element (earliest year) without removing it" do
      # next should return the element with the smallest year_published
      expect(min_heap.next).to eq(book_1932)
      # next should not change the size
      expect(min_heap.size).to eq(books.size)
    end

    it "pops elements in ascending order of year_published" do
      popped_books = []
      while (book = min_heap.pop)
        popped_books << book
      end

      # Verify the popped order matches the expected sorted order
      expect(popped_books).to eq(expected_min_order)

      # Verify the heap is now empty
      expect(min_heap.size).to eq(0)
      expect(min_heap.empty?).to be true
      expect(min_heap.pop).to be_nil # Popping an empty heap
      expect(min_heap.next).to be_nil # Getting next from an empty heap
    end

    it "correctly updates size after popping" do
       expect(min_heap.size).to eq(books.size)
       min_heap.pop
       expect(min_heap.size).to eq(books.size - 1)
    end
  end


  context "Max-Heap (using a custom comparison block)" do
    # Initialize heap with books and a block for max-heap behavior
    # The block returns true if x should have higher priority (be "larger") than y
    let(:max_heap) { ::Containers::Heap.new(books) { |x, y| x > y } } # Use > from Comparable

    it "initializes with the correct size" do
      expect(max_heap.size).to eq(books.size)
      expect(max_heap.empty?).to be false
    end

    it "gets the next maximum element (latest year) without removing it" do
      # next should return the element with the largest year_published
      expect(max_heap.next).to eq(book_1989)
      # next should not change the size
      expect(max_heap.size).to eq(books.size)
    end

    it "pops elements in descending order of year_published" do
      popped_books = []
      while (book = max_heap.pop)
        popped_books << book
      end

      # Verify the popped order matches the expected reversed sorted order
      expect(popped_books).to eq(expected_max_order)

      # Verify the heap is now empty
      expect(max_heap.size).to eq(0)
      expect(max_heap.empty?).to be true
      expect(max_heap.pop).to be_nil # Popping an empty heap
      expect(max_heap.next).to be_nil # Getting next from an empty heap
    end

     it "correctly updates size after popping" do
       expect(max_heap.size).to eq(books.size)
       max_heap.pop
       expect(max_heap.size).to eq(books.size - 1)
    end
  end

  context "Edge cases" do
    it "handles an empty initialization" do
      heap = ::Containers::Heap.new([])
      expect(heap.size).to eq(0)
      expect(heap.empty?).to be true
      expect(heap.pop).to be_nil
      expect(heap.next).to be_nil
    end

    it "handles initialization with one element" do
      heap = ::Containers::Heap.new([book_1965])
      expect(heap.size).to eq(1)
      expect(heap.next).to eq(book_1965)
      expect(heap.pop).to eq(book_1965)
      expect(heap.empty?).to be true
    end
  end

end

describe Containers::Heap do
  before(:each) do
    @heap = Containers::MaxHeap.new
  end

  it "should run without error when given Objects and a non-ordering comparator" do
    # Create and store the initial distinct objects
    initial_objects = 10.times.map { Object.new }
    initial_object_ids = initial_objects.map(&:object_id) # Store IDs for comparison

    min_heap = ::Containers::Heap.new(initial_objects) { |x, y| (x <=> y) == -1 }

    expect(min_heap.size).to eq(10)

    popped_elements = []
    expect {
      while val = min_heap.pop do
        popped_elements << val
      end
    }.not_to raise_error

    expect(min_heap.empty?).to be true
    expect(popped_elements.size).to eq(10)

    # Assert that exactly the same objects were returned, regardless of order.
    # Comparing by object_id is the most reliable way for distinct Objects.
    expect(popped_elements.map(&:object_id)).to contain_exactly(*initial_object_ids)
  end
  
  it "should not let you merge with non-heaps" do
    expect { @heap.merge!(nil) }.to raise_error(ArgumentError)
    expect { @heap.merge!([]) }.to raise_error(ArgumentError)
  end
  
  describe "(empty)" do
  
    it "should return nil when getting the maximum" do
      expect(@heap.max!).to be_nil
    end
    
    it "should let you insert and remove one item" do
      expect(@heap.size).to eql(0)
      
      @heap.push(1)
      expect(@heap.size).to eql(1)
      
      expect(@heap.max!).to eql(1)
      expect(@heap.size).to eql(0)
    end
    
    it "should let you initialize with an array" do
      @heap = Containers::MaxHeap.new([1,2,3])
      expect(@heap.size).to eql(3)
    end

  end
  
  describe "(non-empty)" do
    before(:each) do
      @random_array = []
      @num_items = 100
      @num_items.times { @random_array << rand(@num_items) }
      @heap = Containers::MaxHeap.new(@random_array)
    end
    
    it "should display the correct size" do
      expect(@heap.size).to eql(@num_items)
    end
    
    it "should have a next value" do
      expect(@heap.next).to be_truthy
      expect(@heap.next_key).to be_truthy
    end
    
    it "should delete random keys" do
      expect(@heap.delete(@random_array[0])).to eql(@random_array[0])
      expect(@heap.delete(@random_array[1])).to eql(@random_array[1])
      ordered = []
      ordered << @heap.max! until @heap.empty?
      expect(ordered).to eql( @random_array[2..-1].sort.reverse )
    end
    
    it "should delete all keys" do
      ordered = []
      @random_array.size.times do |t|
        ordered << @heap.delete(@random_array[t])
      end
      expect(@heap).to be_empty
      expect(ordered).to eql( @random_array )
    end

    it "should be in max->min order" do
      ordered = []
      ordered << @heap.max! until @heap.empty?
      
      expect(ordered).to eql(@random_array.sort.reverse)
    end
    
    it "should change certain keys" do
      numbers = [1,2,3,4,5,6,7,8,9,10,100,101]
      heap = Containers::MinHeap.new(numbers)
      heap.change_key(101, 50)
      heap.pop
      heap.pop
      heap.change_key(8, 0)
      ordered = []
      ordered << heap.min! until heap.empty?
      expect(ordered).to eql( [8,3,4,5,6,7,9,10,101,100] )
    end
    
    it "should not delete keys it doesn't have" do
      expect(@heap.delete(:nonexisting)).to be_nil
      expect(@heap.size).to eql(@num_items)
    end
    
    it "should delete certain keys" do
      numbers = [1,2,3,4,5,6,7,8,9,10,100,101]
      heap = Containers::MinHeap.new(numbers)
      heap.delete(5)
      heap.pop
      heap.pop
      heap.delete(100)
      ordered = []
      ordered << heap.min! until heap.empty?
      expect(ordered).to eql( [3,4,6,7,8,9,10,101] )
    end
    
    it "should let you merge with another heap" do
      numbers = [1,2,3,4,5,6,7,8]
      otherheap = Containers::MaxHeap.new(numbers)
      expect(otherheap.size).to eql(8)
      @heap.merge!(otherheap)
      
      ordered = []
      ordered << @heap.max! until @heap.empty?
      
      expect(ordered).to eql( (@random_array + numbers).sort.reverse)
    end
    
    describe "min-heap" do
      it "should be in min->max order" do
        @heap = Containers::MinHeap.new(@random_array)
        ordered = []
        ordered << @heap.min! until @heap.empty?
    
        expect(ordered).to eql(@random_array.sort)
      end
    end
    
  end
  
end
