# puzzle 1 - 4
# puzzle 2 - 14
RING_SIZE = 14

ring = []
ring_pos = 0

File.open('./input.txt', 'r').each_char.with_index do |char, index|
  ring[ring_pos] = char

  if ring.size == RING_SIZE && ring.uniq.count == RING_SIZE
    puts "found signal: #{index + 1}"  
    return
  end

  puts ring.inspect

  if ring_pos == RING_SIZE - 1
    ring_pos = 0
  else
    ring_pos += 1
  end
end

