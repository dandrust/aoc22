Distance = Point = Struct.new(:x, :y) do 
  def +(other)
    Distance.new(x + other.x, y + other.y)
  end

  def -(other)
    Distance.new(x - other.x, y - other.y)
  end

  def move(dist)
    self.x += dist.x
    self.y += dist.y
  end

  def to_s
    "(#{x}, #{y})"
  end
end

LEFT  = Distance.new(-1, 0)
RIGHT = Distance.new(1, 0)
UP    = Distance.new(0, 1)
DOWN  = Distance.new(0, -1)

OVERLAPPING = Distance.new(0, 0)

class Rope
  attr_reader :knots

  def initialize(length = 2, debug: false)
    @head = Point.new(0, 0)
    @tail = Point.new(0, 0)
    @knots = []
    length.times { @knots << Point.new(0, 0) }
    @debug = debug
  end

  def move(dir, count)
    count.times do 
      move_head(dir)
      (1..knots.size - 1).each { |pos| move_follower(pos) }
      yield knots.first, knots.last if block_given?
    end
  end

  private
  attr_reader :debug

  def head
    knots.first
  end

  def move_head(dir)
    puts "Moving HEAD from #{head}" if debug
    case dir
    when "L"
      head.move(LEFT)
    when "R"
      head.move(RIGHT)
    when "U"
      head.move(UP)
    when "D"
      head.move(DOWN)
    end
    puts "              to #{head}" if debug
  end

  def move_follower(pos)
    leader = knots[pos - 1]
    follower = knots[pos]

    distance = leader - follower
    puts "Knot #{pos} is #{distance} from knot #{pos -1}" if debug
    return if distance == OVERLAPPING

    if distance.x.abs == 2 || distance.y.abs == 2 # we need to move somewhere
      puts "Moving knot #{pos} from #{follower}" if debug

      # This isn't super clear. Basically reduce the distance so that you're
      # moving by only one.
      distance.y /= 2 if distance.y.abs == 2 
      distance.x /= 2 if distance.x.abs == 2

      follower.move(distance)
      puts "                     to #{follower}" if debug
    end
  end
end



def simulate_rope(length)
  input = File.open('./input.txt', 'r')
  moves = input.each_line
  r = Rope.new(length)
  tail_positions = []

  moves.each do |move|
    dir, count = *move.chomp.split(" ")

    r.move(dir, Integer(count)) do |_head, tail|
      tail_positions << tail.dup
    end
  end
  input.close

  tail_positions.uniq.count
end

puts "puzzle 1: #{simulate_rope(2)}"
puts "puzzle 2: #{simulate_rope(10)}"

