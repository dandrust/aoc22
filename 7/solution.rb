# Directory builder helpers
class Node
  attr_reader :name, :size
  attr_accessor :children
  def initialize(name, size=nil)
    @name = name
    @size = size
    @children = []
  end
end

def build_directory
  # Use a stack to tell where we are in the tree
  stack = []
  root = Node.new("/")
  stack.push(root)

  File.open('./input.txt', 'r').lines do |line|
    input = line.chomp

    if input.start_with?("$ cd")
      path = input[5...]
      case path
      when '/'
        stack.clear
        stack.push(root)
      when '..'
        stack.pop
      else
        dir = stack.last.children.detect { |f| f.name == path }
        raise "Could not locate directory" unless dir
        stack.push(dir)
      end
    elsif input.start_with?("$ ls")
      # No op. The following lines will be added to the tree
    else
      parent = stack.last
      if input.start_with?("dir")
        dirname = input[4...]
        parent.children.push(Node.new(dirname))
      elsif input.match? /\d+\s\w+\.?\w*/
        size, filename = input.split(" ")
        parent.children.push(Node.new(filename, Integer(size)))
      end
    end  
  end

  root
end

def print_directory(node)
  print_dfs(node, 0)
end

def print_dfs(node, level)
  indent = "  " * level
  dir_symbol = level > 0 ? "+ " : ""
  size = node.size ? "(#{node.size})" : ""
  puts "#{indent}#{dir_symbol}#{node.name} #{size}"
  node.children.each { |child| print_dfs(child, level + 1) }
end

# Puzzle 1 helper. Use depth-first search to calculate directory sizes
def dfs(node, &block)
  # Leaf node
  if !node.children
    return node.size 
  end

  # Get the size of this node based on children
  size = node.children.sum do |child|
    child.size || dfs(child, &block)
  end

  # Do stuff like log size, depending on puzzle
  yield size if block_given?
  
  return size
end

# Puzzle 2 helper. Find the first value greater than target
def binary_search(arr, target)
  left = 0
  right = arr.count - 1
  lowest_viable_candidate = nil

  while left < right do
    mid = (left + right) / 2
    if arr[mid] > target
      lowest_viable_candidate = arr[mid]
      right = mid - 1
    else
      left = mid + 1
    end
  end

  lowest_viable_candidate
end

def main
  root = build_directory
  agg = 0
  directory_sizes = []
  space_used = dfs(root) do |directory_size|
    # For puzzle 2
    directory_sizes << directory_size

    # For puzzle 1
    if directory_size <= 100_000
      agg += directory_size
    end
  end

  puts "puzzle 1: #{agg}"

  total_space    = 70_000_000
  space_required = 30_000_000
  currently_free = total_space - space_used
  to_free        = space_required - currently_free

  puts "puzzle 2: #{binary_search(directory_sizes.sort, to_free)}"
end

main