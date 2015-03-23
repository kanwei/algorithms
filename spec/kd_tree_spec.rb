$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'algorithms'

describe Containers::KDTree do
  it 'should work for a documented example' do
    kdtree = Containers::KDTree.new(0 => [4, 3], 1 => [3, 0], 2 => [-1, 2], 3 => [6, 4],
                                    4 => [3, -5], 5 => [-2, -5])
    closest2 = kdtree.find_nearest([0, 0], 2)
    expect(closest2).to eql([[5, 2], [9, 1]])
  end

  it 'should work for real-life example from facebook puzzle' do
    points = {}
    input = File.open(File.join(File.dirname(__FILE__), 'kd_test_in.txt'), 'r')

    # Populate points hash
    input.each_line do |line|
      break if line.empty?
      n, x, y = line.split(/\s+/)
      points[n.to_i] = [x.to_f, y.to_f]
    end

    out = ''
    kdtree = Containers::KDTree.new(points)
    points.sort { |(k1, _v1), (k2, _v2)| k1 <=> k2 }.each do |id, point|
      nearest4 = kdtree.find_nearest(point, 4)
      out << "#{id} #{nearest4[1..-1].collect { |n| n[1] }.join(',')}\n"
    end

    expected = File.read(File.join(File.dirname(__FILE__), 'kd_expected_out.txt'))
    expect(expected).to eql(out)
  end
end
