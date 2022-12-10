class Part1
	def initialize
		@headx = @heady = 0i32
		@tailx = @taily = 0i32
		@seen = { { 0i32, 0i32 } => nil }
	end

	getter seen

	private def add_pos
		@seen[{ @tailx, @taily }] = nil
	end

	macro move(a, b)
		old = @head{{a}}

		@head{{a}} = old + inc

		if old - @tail{{a}} == inc
			@tail{{a}} = old
			@tail{{b}} = @head{{b}}
			add_pos()
		end
	end

	private def hmove(inc : Int)
		move(x, y)
	end

	private def vmove(inc : Int)
		move(y, x)
	end

	def parse(line : String)
		direction = line[0]
		n = line[2 .. -1].to_i()

		n.times do
			case direction
			when 'R' then hmove +1
			when 'L' then hmove -1
			when 'D' then vmove +1
			when 'U' then vmove -1
			end
		end
	end
end

parser = Part1.new()
STDIN.each_line &->parser.parse(String)
puts parser.seen.size
