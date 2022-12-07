@puzzle = 2
@state = :build
@stacks = [
  [],
  [],
  [],
  [],
  [],
  [],
  [],
  [],
  []
]

def allocate_to_stacks(line)
  line.split("").each_slice(4).with_index do |content, index|
    next if content[1] == " " || content[1].match?(/\d/)
    @stacks[index].unshift(content[1])
  end
end

def print_stacks
  @stacks.each.with_index { |s, i| puts "#{i+1}: #{s}"}
end

def move_crates(line)
  _, num, _, raw_src, _, raw_dst = line.chomp.split(" ")
  # puts "#{raw_src} -> #{raw_dst} (#{num})"
  src_stack = @stacks[Integer(raw_src) - 1]
  dst_stack = @stacks[Integer(raw_dst) - 1]
  
  if @puzzle == 1
    Integer(num).times do
      dst_stack.push(src_stack.pop)
    end
  else # 2
    dst_stack.concat(src_stack.pop(Integer(num)))
  end
end

File.open('./input.txt', 'r').each_line do |line|
# File.open('./input.txt', 'r').lines.first(11).each do |line| 
  if @state == :build
    if line.chomp == ""
      # puts "Finished building"
      @state = :move
      next 
    end
    
    allocate_to_stacks(line)
  else # move!
    move_crates(line)
  end
end

print_stacks

puts "#{ @stacks.map { |s| s.last }.join("") }"