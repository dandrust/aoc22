class Cpu
  attr_reader :clock, :x, :during_tick

  def initialize(&during_tick)
    @clock = 0
    @x = 1
    @during_tick = during_tick
  end

  def tick
    @clock += 1
    during_tick.call(clock, x) # "during" state
    yield if block_given? # instruction finishes
  end

  def addx(value)
    tick
    tick { @x += value  }
  end

  def noop(_)
    tick
  end
end

def run_program(&block)
  input = File.open('./input.txt', 'r')
  program = input.each_line
  cpu = Cpu.new(&block)

  program.each do |instruction|
    op, value = instruction.chomp.split(" ")
    value = Integer(value) unless value.nil?

    cpu.send(op.to_sym, value)
  end
  
  input.close
end


signal_log = {}
run_program do |clk, x|
  # Capture value of X register when clock is 20, then every
  # 40th tick after

  if (clk - 20) % 40 == 0
    signal_strength = clk * x
    signal_log[clk] = signal_strength
  end
end

puts "puzzle 1: #{signal_log.values.sum}"

class Crt
  WIDTH = 40
  attr_reader :buffer, :sprite_pos, :cpu

  def initialize
    @x = 0
    @y = 0
    @buffer = []
  end

  def on_tick(x)
    @sprite_pos = x 
    draw
  end

  def draw
    buffer << (sprite_in_view? ? "#" : ".")
    flush if end_of_line?
  end

  def end_of_line?
    buffer.size % WIDTH == 0
  end

  def flush
    puts buffer.join("")
    buffer.clear
  end

  def sprite_in_view?
    (buffer.size - sprite_pos).abs <= 1
  end
end

crt = Crt.new
puts "puzzle 2:"
run_program { |_, x| crt.on_tick(x) }



