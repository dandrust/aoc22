possible_values = ("a".."z").to_a.concat(("A".."Z").to_a)
VALUES = possible_values.map.with_index { |v, index| [v, index + 1]}.to_h.freeze

result_1 = File.open("./input.txt", "r").readlines.sum do |data|
  VALUES[data.chomp.chars.each_slice(data.size/2).reduce(&:&)[0]]
end

puts "puzzle 1: #{result_1}" # 8349

# ===============

result_2 = File.open("./input.txt", "r").lines.each_slice(3).sum do |lines|
  VALUES[lines.map(&:chars).reduce(&:&)[0]]
end

puts "puzzle 2: #{result_2}" # 2681