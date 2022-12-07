def count_contains(a, b, c, d)
  return 1 if a == c || b == d
  
  if a < c
    # a . . . . . b
    #     c . . d
    return 1 if b > d
  else
    #     a . . b
    # c . . . . . d
    return 1 if d > b
  end
  0
end

def count_overlaps(a, b, c, d)
  return 1 if count_contains(a, b, c, d) == 1

  if a < c
    # a . . . . . b
    #     c . . . . . d
    return 1 if c <= b
  else
    #     a . . . . . b
    # c . . . . . d
    return 1 if a <= d
  end
  0
end

solution_1 = File.open("./input.txt", "r").readlines.sum do |line|
  count_contains(*line.chomp.split(",").map { |r| r.split("-") }.flatten.map { |n| Integer(n) })
end

solution_2 = File.open("./input.txt", "r").readlines.sum do |line|
  count_overlaps(*line.chomp.split(",").map { |r| r.split("-") }.flatten.map { |n| Integer(n) })
end

puts "puzzle 1: #{solution_1}"
puts "puzzle 2: #{solution_2}"


puts "COUNT CONTAINS"
# First contains second, second contains first
puts "Expect 1-10,2-9 to be true:  #{count_contains(1, 10, 2, 9)}"
puts "Expect 2-9,1-10 to be true:  #{count_contains(2, 9, 1, 10)}"

# Both exclusive
puts "Expect 1-2,3-4  to be false: #{count_contains(1, 2, 3, 4)}"
puts "Expect 1-2,3-4  to be false: #{count_contains(3, 4, 1, 2)}"

# First is single subset of second
puts "Expect 1-1,1-6  to be true:  #{count_contains(1, 1, 1, 6)}"
puts "Expect 6-6,1-6  to be true:  #{count_contains(6, 6, 1, 6)}"

# Second is single subset of first
puts "Expect 1-1,1-6  to be true:  #{count_contains(1, 6, 1, 1)}"
puts "Expect 6-6,1-6  to be true:  #{count_contains(1, 6, 6, 6)}"

puts "COUNT OVERLAP"
puts "Expect 1-10,2-9 to be true:  #{count_overlaps(1, 10, 2, 9)}"
puts "Expect 2-9,1-10 to be true:  #{count_overlaps(2, 9, 1, 10)}"

# Both exclusive
puts "Expect 1-2,3-4  to be false: #{count_overlaps(1, 2, 3, 4)}"
puts "Expect 1-2,3-4  to be false: #{count_overlaps(3, 4, 1, 2)}"

# First is single subset of second
puts "Expect 1-1,1-6  to be true:  #{count_overlaps(1, 1, 1, 6)}"
puts "Expect 6-6,1-6  to be true:  #{count_overlaps(6, 6, 1, 6)}"

# Second is single subset of first
puts "Expect 1-1,1-6  to be true:  #{count_overlaps(1, 6, 1, 1)}"
puts "Expect 6-6,1-6  to be true:  #{count_overlaps(1, 6, 6, 6)}"

# overlap with identical start/end
puts "Expect 1-2,2-3  to be true:  #{count_overlaps(1, 2, 2, 3)}"
puts "Expect 1-2,2-3  to be true:  #{count_overlaps(2, 3, 1, 2)}"

# overlap by one
puts "Expect 1-3,2-4  to be true:  #{count_overlaps(1, 3, 2, 4)}"
puts "Expect 1-3,2-4  to be true:  #{count_overlaps(2, 4, 1, 3)}"