leaders = [0, 0, 0]
current = 0

File.open('./input.txt', 'r').each_line do |line|
  if line == "\n"
    if current > leaders.last
      leaders.pop
      leaders.push(current)
      leaders = leaders.sort.reverse
    end
    
    current = 0
  else
    current += Integer(line)
  end
end.close

puts "puzzle 1: #{leaders.first}"
puts "puzzle 2: #{leaders.sum}"