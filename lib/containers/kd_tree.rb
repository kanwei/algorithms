=begin rdoc

    A kd-tree is a binary tree that allows one to store points (of any space dimension: 2D, 3D, etc). 
    The structure of the resulting tree makes it so that large portions of the tree are pruned
    during queries.
    
    One very good use of the tree is to allow nearest neighbor searching. Let's say you have a number
    of points in 2D space, and you want to find the nearest 2 points from a specific point:
    
    First, put the points into the tree:
    
      kdtree = Containers::KDTree.new( {0 => [4, 3], 1 => [3, 4], 2 => [-1, 2], 3 => [6, 4],
                                       4 => [3, -5], 5 => [-2, -5] })
    
    Then, query on the tree:
    
      puts kd.find_nearest([0, 0], 2) => [[5, 2], [9, 1]]
      
    The result is an array of [distance, id] pairs. There seems to be a bug in this version.
      
    Note that the point queried on does not have to exist in the tree. However, if it does exist,
    it will be returned.

=end

class Containers::KDTree
  Node = Struct.new(:id, :coords, :left, :right)
  
  # Points is a hash of id => [coord, coord] pairs.
  def initialize(points)
    raise "must pass in a hash" unless points.kind_of?(Hash)
    @dimensions = points[ points.keys.first ].size
    @root = build_tree(points.to_a)
    @nearest = []
  end
  
  # Find k closest points to given coordinates 
  def find_nearest(target, k_nearest)
    @nearest = []
    nearest(@root, target, k_nearest, 0)
  end
  
  # points is an array
  def build_tree(points, depth=0)
    return if points.empty?
    
    axis = depth % @dimensions
    
    points.sort! { |a, b| a.last[axis] <=> b.last[axis] }
    median = points.size / 2
    
    node = Node.new(points[median].first, points[median].last, nil, nil)
    node.left = build_tree(points[0...median], depth+1)
    node.right = build_tree(points[median+1..-1], depth+1)
    node
  end
  private :build_tree

  # Euclidian distanced, squared, between a node and target coords
  def distance2(node, target)
    return nil if node.nil? or target.nil?
    c = (node.coords[0] - target[0])
    d = (node.coords[1] - target[1])
    c * c + d * d
  end
  private :distance2

  # Update array of nearest elements if necessary
  def check_nearest(nearest, node, target, k_nearest)
    d = distance2(node, target) 
    if nearest.size < k_nearest || d < nearest.last[0]
      nearest.pop if nearest.size >= k_nearest
      nearest << [d, node.id]
      nearest.sort! { |a, b| a[0] <=> b[0] }
    end
    nearest
  end
  private :check_nearest
  
  # Recursively find nearest coordinates, going down the appropriate branch as needed
  def nearest(node, target, k_nearest, depth)
    axis = depth % @dimensions
  
    if node.left.nil? && node.right.nil? # Leaf node
      @nearest = check_nearest(@nearest, node, target, k_nearest)
      return
    end
  
    # Go down the nearest split
    if node.right.nil? || (node.left && target[axis] <= node.coords[axis])
      nearer = node.left
      further = node.right
    else
      nearer = node.right
      further = node.left
    end
    nearest(nearer, target, k_nearest, depth+1)
  
    # See if we have to check other side
    if further
      if @nearest.size < k_nearest || (target[axis] - node.coords[axis])**2 < @nearest.last[0]
        nearest(further, target, k_nearest, depth+1)
      end
    end
  
    @nearest = check_nearest(@nearest, node, target, k_nearest)
  end
  private :nearest
  
end
