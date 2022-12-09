forest = File.open('./input.txt', 'r').lines.map { |l| l.chomp.split("").map { |n| Integer(n) } }

# forest = [
#   [3, 0, 3, 7, 3],
#   [2, 5, 5, 1, 2],
#   [6, 5, 3, 3, 2],
#   [3, 3, 5, 4, 9], 
#   [3, 5, 3, 9, 0]
# ]

# trp_rev = [
#   [3, 3, 6, 2, 3],
#   [5, 3, 5, 5, 0],
#   [3, 5, 3, 5, 3], 
#   [9, 4, 3, 1, 7], 
#   [0, 9, 2, 2, 3]
# ]

# transposed = [
#   [3, 2, 6, 3, 3], 
#   [0, 5, 5, 3, 5], 
#   [3, 5, 3, 5, 3], 
#   [7, 1, 3, 4, 9], 
#   [3, 2, 2, 9, 0]
# ]

visibles = []

def print_array(a)
  a.each do |row|
    puts row[0..98].map { |n| n.nil? ? "." : "T" }.join
  end
end

# n = 1
# baseline = row.first
# max = row.max
# leftmost_max = row.index(max)
# visibles[n] ||= []
# visibles[n][leftmost_max] = true

forest.each.with_index do |row, n|
  visibles[n] = []
  left_bound = 0
  right_bound = row.size - 1
  baseline = row.first
  max = row.max

  target = max

  while target >= baseline || right_bound == 0

    puts "Looking for #{target} in #{row[left_bound..right_bound]}"
    # find the position if it exists
    pos = row[left_bound..right_bound].index(target) # restrict to search space, inclusive
    if pos == nil
      # if not, iterate to look for the next smallest tree
      puts "#{target} not found between (#{left_bound}..#{right_bound})"
      target -= 1
      next
    end
    puts "Found #{target} at position #{pos}!"

    # log the position as visible
    visibles[n][pos] = true

    # print_array(visibles)

    # shrink the search space
    right_bound = pos - 1
    target -= 1
  end
  puts "finished searching left!\n"

  left_bound = row.index(max) + 1 # Right search space starts at leftmost max position, exclusive (don't count twice!)
  right_bound = row.size - 1
  baseline = row.last

  target = max

  while target >= baseline || left_bound == row.size - 1
    # gets
    puts "Looking for #{target} in (#{left_bound}..#{right_bound}): #{row[left_bound..right_bound]}"
    # find the position if it exists
    pos = row[left_bound..right_bound].rindex(target) # restrict to search space, inclusive
    if pos == nil
      # if not, iterate to look for the next smallest tree
      puts "#{target} not found between (#{left_bound}..#{right_bound})"
      target -= 1
      next
    end
    puts "Found #{target} at local position #{pos}!"
    actual_pos = left_bound + pos
    puts "\tAbsolute position #{actual_pos}"

    # log the position as visible
    visibles[n][actual_pos] = true
    # print_array(visibles)

    # shrink the search space
    left_bound = actual_pos + 1
    target -= 1
  end
end

puts "transposing!"

forest.transpose.each.with_index do |row, n|
  left_bound = 0
  right_bound = row.size - 1
  baseline = row.first
  max = row.max

  target = max

  while target >= baseline || right_bound == 0
    # gets
    puts "Looking for #{target} in #{row[left_bound..right_bound]}"
    # find the position if it exists
    pos = row[left_bound..right_bound].index(target) # restrict to search space, inclusive
    if pos == nil
      # if not, iterate to look for the next smallest tree
      puts "#{target} not found between (#{left_bound}..#{right_bound})"
      target -= 1
      next
    end
    puts "Found #{target} at position #{pos}!"

    # log the position as visible
    visibles[pos][n] = true
    # print_array(visibles)

    # shrink the search space
    right_bound = pos - 1
    target -= 1
  end
  puts "finished searching left!\n"

  left_bound = row.index(max) + 1 # Right search space starts at leftmost max position, exclusive (don't count twice!)
  right_bound = row.size - 1
  baseline = row.last

  target = max

  while target >= baseline || left_bound == row.size - 1
    # gets
    puts "Looking for #{target} in (#{left_bound}..#{right_bound}): #{row[left_bound..right_bound]}"
    # find the position if it exists
    pos = row[left_bound..right_bound].rindex(target) # restrict to search space, inclusive
    if pos == nil
      # if not, iterate to look for the next smallest tree
      puts "#{target} not found between (#{left_bound}..#{right_bound})"
      target -= 1
      next
    end
    puts "Found #{target} at local position #{pos}!"
    actual_pos = left_bound + pos
    puts "\tAbsolute position #{actual_pos}"

    # log the position as visible
    visibles[actual_pos][n] = true
    # print_array(visibles)

    # shrink the search space
    left_bound = actual_pos + 1
    target -= 1
  end
end

puts visibles[0].inspect

# visibles.each do |row|
#   puts row[0..98].map { |n| n.nil? ? "." : "T" }.join
# end

print_array(visibles)

puts visibles.map { |r| r.count(true) }.sum


