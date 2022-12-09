# forest = [
#   [3, 0, 3, 7, 3],
#   [2, 5, 5, 1, 2],
#   [6, 5, 3, 3, 2],
#   [3, 3, 5, 4, 9], 
#   [3, 5, 3, 9, 0]
# ]
# # x -------------->
# transposed = [      # y
#   [3, 2, 6, 3, 3],  # |
#   [0, 5, 5, 3, 5],  # |
#   [3, 5, 3, 5, 3],  # |
#   [7, 1, 3, 4, 9],  # |
#   [3, 2, 2, 9, 0]   # V
# ]

forest = File.open('./input.txt', 'r').lines.map { |l| l.chomp.split("").map { |n| Integer(n) } }
transposed = forest.transpose

memo = []
@debug = true
highest = 0

def print_ary(ary)
  return unless @debug
  puts " #{ary}"
end

def print_pos(pos, len, char = "*")
  return unless @debug
  case pos
  when :oob_low
    puts char
  when :oob_high
    # len numbers + len - 1 commas + len - 1 spaces + 2 brackets + 1 leading space
    total_len = len + ((len - 1) * 2) + 2 + 1
    puts " " * total_len + char
  else Integer
    puts "  " + ("   " * pos) + char
  end
end


forest.each.with_index do |row, y|
  row.each.with_index do |height, x|
    # gets
    puts "Calculating east-west distances for position #{x}"
    print_ary(row)
    print_pos(x, row.size, "^")

    west_pos = row[0...x].rindex { |h| h >= height }
    print_pos(west_pos.nil? ? :oob_low : west_pos, row.size)
    west_dist = west_pos.nil? ? row[0...x].count : x - west_pos

    relative_east_pos = row[x+1..].index { |h| h >= height }
    absolute_east_pos = relative_east_pos.nil? ? nil : relative_east_pos + x + 1
    print_pos(absolute_east_pos.nil? ? :oob_high : absolute_east_pos, row.size)
    east_dist = absolute_east_pos.nil? ? row[x+1..].count : absolute_east_pos - x

    puts "west: #{west_dist}, east: #{east_dist}"
    # # # # # # # # # # # # # # # # # # # # # # # # # # #          
    # gets
    puts "Calculating north-south distances for position #{x}"
    ns_row = transposed[x]
    print_ary(ns_row)
    print_pos(y, ns_row.size, "^")

    north_pos = ns_row[0...y].rindex { |h| h >= height }
    print_pos(north_pos.nil? ? :oob_low : north_pos, ns_row.size)
    north_dist = north_pos.nil? ? ns_row[0...y].count : y - north_pos

    relative_south_pos = ns_row[y+1..].index { |h| h >= height }
    absolute_south_pos = relative_south_pos.nil? ? nil : relative_south_pos + y + 1
    print_pos(absolute_south_pos.nil? ? :oob_high : absolute_south_pos, ns_row.size)
    south_dist = absolute_south_pos.nil? ? ns_row[y+1..].count : absolute_south_pos - y

    puts "north: #{north_dist}, south: #{south_dist}"

    scenic_score = north_dist * south_dist * east_dist * west_dist
    puts "scenic score: #{scenic_score}"
    if scenic_score > highest
      highest_was = highest
      highest = scenic_score
      puts "new high! was #{highest_was}, now #{highest}"
    end
  end
end

puts "highest scenic score is #{highest}"