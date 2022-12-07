score = 0

POSITIONS = {
  "A" => 0,
  "B" => 1,
  "C" => 2,
  "X" => 0,
  "Y" => 1, 
  "Z" => 2
}

OUTCOMES = [
  # R    P    S
  # A    B    C  - them
  [3+1, 0+1, 6+1], # X - me rock
  [6+2, 3+2, 0+2], # Y - me paper
  [0+3, 6+3, 3+3]  # Z - me scisors
]

File.open('./input.txt', 'r').each_line do |line|
  theirs, mine = line.chomp.split(" ")

  score += OUTCOMES[POSITIONS[mine]][POSITIONS[theirs]]
end.close

puts "puzzle 1: #{score}"

###################################

score2 = 0

MY_MOVE = [
#  Rock       Papaer     Scissors
#  A          B          C      - them
  [:scissors, :rock,     :paper],    # X - I lose
  [:rock,     :paper,    :scissors], # Y - I draw
  [:paper,    :scissors, :rock]      # Z - I win
]

POINTS = {
  rock:     1,
  paper:    2,
  scissors: 3, 
  "X" =>    0,
  "Y" =>    3,
  "Z" =>    6
}

File.open('./input.txt', 'r').each_line do |line|
  theirs, outcome = line.chomp.split(" ")
  mine = MY_MOVE[POSITIONS[outcome]][POSITIONS[theirs]]

  score2 += POINTS[outcome] + POINTS[mine]
end.close

puts "puzzle 2: #{score2}"